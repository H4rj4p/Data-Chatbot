from __future__ import annotations

import difflib
import re
from typing import Any

import pandas as pd

from app.analytics.models import ChatAnswer

TOP_N = re.compile(r"\btop\s+(\d+)\b", re.IGNORECASE)
STARTS_WITH = re.compile(
    r"start(?:s)?\s+with\s+(?:the\s+letter\s+)?['\"]?([a-zA-Z])",
    re.IGNORECASE,
)
COUNT_QUESTION = re.compile(
    r"\b(how many|how much|count|total number|number of)\b",
    re.IGNORECASE,
)

COLUMN_HINTS: dict[str, tuple[str, ...]] = {
    "salary": ("salary", "pay", "wage", "compensation", "income"),
    "name": ("name", "employee", "person"),
    "age": ("age",),
    "department": ("department", "dept", "team", "role", "job", "title"),
    "city": ("city", "location", "office"),
}

CHART_WORDS = ("chart", "graph", "plot", "visual", "visualize", "bar chart", "pie chart")
TABLE_WORDS = ("table", "list", "show me", "display")


def _normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text.lower()).strip()


def _word_in_question(word: str, question: str) -> bool:
    q = _normalize(question)
    lower = word.lower()
    forms = {lower}
    if lower.endswith("y"):
        forms.add(lower[:-1] + "ies")
    forms.add(lower + "s")
    forms.add(lower + "es")
    return any(re.search(rf"\b{re.escape(form)}\b", q) for form in forms)


def _term_matches_column(term: str, col: str) -> bool:
    term_norm = term.lower().replace("_", " ").strip().rstrip("s")
    col_norm = str(col).lower().replace("_", " ")
    if term_norm == col_norm.rstrip("s"):
        return True
    col_lower = str(col).lower()
    for key, hints in COLUMN_HINTS.items():
        if key in col_lower and any(term_norm == hint.rstrip("s") for hint in hints):
            return True
    return False


def _column_mentioned(question: str, col: str) -> bool:
    col_norm = str(col).lower().replace("_", " ")
    if _word_in_question(col_norm, question):
        return True
    col_lower = str(col).lower()
    for key, hints in COLUMN_HINTS.items():
        if key in col_lower:
            for hint in hints:
                if _word_in_question(hint, question):
                    return True
    return False


def _wants_chart(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in CHART_WORDS)


def _wants_table(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in TABLE_WORDS) or bool(TOP_N.search(q))


def _group_term(question: str) -> str | None:
    q = _normalize(question)
    if _wants_sort(question):
        return None

    agg_match = re.search(
        r"\b(?:average|avg|mean|group|breakdown|per)\s+[\w ]+?\s+by\s+([a-z][a-z0-9_ ]*?)(?:\s|$)",
        q,
    )
    if agg_match:
        return agg_match.group(1).strip()

    match = re.search(r"\bby\s+([a-z][a-z0-9_ ]*?)(?:\s|$)", q)
    return match.group(1).strip() if match else None


def _fuzzy_word_match(a: str, b: str) -> bool:
    a = a.rstrip("s").lower()
    b = b.rstrip("s").lower()
    if a == b:
        return True
    if len(a) < 4 or len(b) < 4:
        return False
    return difflib.SequenceMatcher(None, a, b).ratio() >= 0.8


def _value_matches_question(value: str, question: str) -> bool:
    words = _normalize(value).split()
    if not words:
        return False

    pattern = r"\b" + r"\s+".join(f"{re.escape(word.rstrip('s'))}s?" for word in words) + r"\b"
    if re.search(pattern, _normalize(question)):
        return True

    q_words = _normalize(question).split()
    used: set[int] = set()
    for value_word in words:
        matched = False
        for index, question_word in enumerate(q_words):
            if index in used:
                continue
            if _fuzzy_word_match(value_word, question_word):
                used.add(index)
                matched = True
                break
        if not matched:
            return False
    return True


def _find_categorical_filter(question: str, df: pd.DataFrame) -> tuple[str, str] | None:
    best: tuple[str, str, int] | None = None
    name_col = _find_name_column(df)
    for col in df.columns:
        if col == name_col or pd.api.types.is_numeric_dtype(df[col]):
            continue
        for value in df[col].dropna().astype(str).unique():
            if not _value_matches_question(value, question):
                continue
            score = len(_normalize(value))
            if best is None or score > best[2]:
                best = (col, value, score)
    if best is None:
        return None
    return best[0], best[1]


def _wants_sort(question: str) -> bool:
    q = _normalize(question)
    return any(
        phrase in q
        for phrase in (
            "sort",
            "sorted",
            "order",
            "ordered",
            "rank",
            "ranked",
            "low to high",
            "high to low",
            "lowest to highest",
            "highest to lowest",
            "from low to high",
            "from high to low",
        )
    )


def _direction_ascending(direction: str) -> bool:
    d = _normalize(direction)
    if any(phrase in d for phrase in ("low to high", "lowest to highest")):
        return True
    if any(phrase in d for phrase in ("high to low", "highest to lowest")):
        return False
    return True


def _column_for_term(
    term: str,
    df: pd.DataFrame,
    *,
    exclude_terms: set[str] | None = None,
) -> str | None:
    excluded = {t.lower() for t in (exclude_terms or set())}
    for col in df.columns:
        if _column_excluded(col, excluded):
            continue
        if _term_matches_column(term, col):
            return col
    return None


def _format_sort_title(specs: list[tuple[str, bool]]) -> str:
    parts: list[str] = []
    for col, ascending in specs:
        direction = "low to high" if ascending else "high to low"
        parts.append(f"{col} ({direction})")
    return ", ".join(parts)


def _sort_specs(
    question: str,
    df: pd.DataFrame,
    *,
    exclude_terms: set[str] | None = None,
) -> list[tuple[str, bool]]:
    if not _wants_sort(question):
        return []

    q = _normalize(question)
    specs: list[tuple[str, bool]] = []
    seen: set[str] = set()

    direction_pattern = re.compile(
        r"(low\s+to\s+high|high\s+to\s+low|lowest\s+to\s+highest|highest\s+to\s+lowest)",
    )
    for match in direction_pattern.finditer(q):
        before = q[: match.start()].rstrip()
        words = before.split()
        matched_col = None
        for width in range(1, min(4, len(words) + 1)):
            term = " ".join(words[-width:])
            col = _column_for_term(term, df, exclude_terms=exclude_terms)
            if col:
                matched_col = col
                break
        if matched_col and matched_col not in seen:
            specs.append((matched_col, _direction_ascending(match.group(1))))
            seen.add(matched_col)

    if len(specs) > 1:
        return specs
    if len(specs) == 1:
        return specs

    from_match = re.search(
        r"\b(?:their|the)\s+([a-z][a-z0-9_ ]*?)\s+from\s+"
        r"(?:low\s+to\s+high|high\s+to\s+low|lowest\s+to\s+highest|highest\s+to\s+lowest)",
        q,
    )
    if from_match:
        term = from_match.group(1).strip()
        col = _column_for_term(term, df, exclude_terms=exclude_terms)
        if col:
            return [(col, _sort_ascending(question))]

    by_match = re.search(
        r"\b(?:sort(?:ed)?|order(?:ed)?|rank(?:ed)?)\s+(?:them\s+)?(?:by\s+)?(?:their\s+)?([a-z][a-z0-9_ ]*?)(?:\s+from|\s|$)",
        q,
    )
    if not by_match:
        by_match = re.search(r"\bby\s+(?:their\s+)?([a-z][a-z0-9_ ]*?)(?:\s+from|\s|$)", q)
    if by_match:
        term = by_match.group(1).strip()
        col = _column_for_term(term, df, exclude_terms=exclude_terms)
        if col:
            return [(col, _sort_ascending(question))]

    mentioned_numeric = [
        col
        for col in df.columns
        if _column_mentioned(question, col) and pd.api.types.is_numeric_dtype(df[col])
    ]
    if mentioned_numeric:
        col = max(mentioned_numeric, key=lambda c: len(str(c)))
        return [(col, _sort_ascending(question))]

    col = _find_column(question, df, exclude_terms=exclude_terms)
    if col and pd.api.types.is_numeric_dtype(df[col]):
        return [(col, _sort_ascending(question))]
    return []


def _sort_column(
    question: str,
    df: pd.DataFrame,
    *,
    exclude_terms: set[str] | None = None,
) -> str | None:
    specs = _sort_specs(question, df, exclude_terms=exclude_terms)
    return specs[0][0] if specs else None


def _columns_for_filter_display(
    question: str,
    df: pd.DataFrame,
    filter_col: str,
) -> list[str]:
    name_col = _find_name_column(df)
    mentioned = [
        col
        for col in df.columns
        if _column_mentioned(question, col) and not _column_excluded(col, set())
    ]
    if mentioned:
        cols = [name_col] if name_col and name_col not in mentioned else []
        return list(dict.fromkeys([*cols, *mentioned]))

    if name_col:
        return [name_col]
    return [col for col in df.columns if col != filter_col]


def _table_sections(
    df: pd.DataFrame,
    sort_specs: list[tuple[str, bool]],
    *,
    base_label: str,
    name_col: str | None,
) -> list[dict[str, Any]]:
    sections: list[dict[str, Any]] = []
    for col, ascending in sort_specs:
        if col not in df.columns:
            continue
        direction = "low to high" if ascending else "high to low"
        section_cols = list(
            dict.fromkeys([c for c in [name_col, col] if c and c in df.columns])
        )
        section_df = df.sort_values(col, ascending=ascending)[section_cols]
        columns, rows = _df_to_rows(section_df)
        sections.append(
            {
                "title": f"{base_label} by {col} ({direction})",
                "columns": columns,
                "rows": rows,
            }
        )
    return sections


def _filter_answer(
    question: str,
    df: pd.DataFrame,
    filter_col: str,
    filter_value: str,
) -> ChatAnswer:
    filtered = df[df[filter_col].astype(str).str.lower() == filter_value.lower()].copy()
    sort_specs = _sort_specs(question, df, exclude_terms={filter_value.lower()})
    count = len(filtered)
    label = filter_value if count == 1 else f"{filter_value}s"
    wants_count = bool(COUNT_QUESTION.search(_normalize(question)))
    name_col = _find_name_column(df)

    if count == 0:
        return ChatAnswer(type="text", text=f"There are 0 {label}.")

    if len(sort_specs) > 1:
        if wants_count:
            title = f"{count} {label}"
        else:
            title = f"{label} ({count})"
        return ChatAnswer(
            type="table",
            text=title,
            tables=_table_sections(filtered, sort_specs, base_label=label, name_col=name_col),
        )

    if sort_specs:
        col, ascending = sort_specs[0]
        if col in filtered.columns:
            filtered = filtered.sort_values(col, ascending=ascending)

    display_cols = _columns_for_filter_display(question, df, filter_col)
    if sort_specs:
        sort_col = sort_specs[0][0]
        if sort_col in filtered.columns and sort_col not in display_cols:
            display_cols.append(sort_col)

    result = filtered[display_cols]
    wants_sort = bool(sort_specs)
    sort_title = _format_sort_title(sort_specs)

    if wants_count and wants_sort:
        title = f"{count} {label} sorted by {sort_title}"
    elif wants_count:
        title = f"{count} {label}"
    elif wants_sort:
        title = f"{label} ({count}) sorted by {sort_title}"
    else:
        title = f"{label} ({count})"

    return _table_answer(result, title, question)


def _column_excluded(col: str, exclude_terms: set[str]) -> bool:
    col_norm = str(col).lower().replace("_", " ")
    if col_norm in exclude_terms:
        return True
    col_lower = str(col).lower()
    for hints in COLUMN_HINTS.values():
        if any(h in col_lower for h in hints) and any(h in exclude_terms for h in hints):
            return True
    return False


def _find_column(
    question: str,
    df: pd.DataFrame,
    *,
    exclude_terms: set[str] | None = None,
) -> str | None:
    excluded = {term.lower() for term in (exclude_terms or set())}
    matches: list[str] = []
    for col in df.columns:
        if _column_excluded(col, excluded):
            continue
        col_norm = str(col).lower().replace("_", " ")
        if _word_in_question(col_norm, question):
            matches.append(col)

    if not matches:
        for col in df.columns:
            if _column_excluded(col, excluded):
                continue
            col_lower = str(col).lower()
            for key, hints in COLUMN_HINTS.items():
                if key in col_lower and any(_word_in_question(hint, question) for hint in hints):
                    matches.append(col)
                    break

    if not matches:
        return None
    numeric_matches = [col for col in matches if pd.api.types.is_numeric_dtype(df[col])]
    candidates = numeric_matches or matches
    return max(candidates, key=lambda col: len(str(col)))


def _find_name_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        if "name" in str(col).lower():
            return col
    return df.columns[0] if len(df.columns) else None


DISAMBIGUATION_MARKER = "Which one do you mean?"

PERSON_LOOKUP_PHRASES = (
    "information on",
    "information about",
    "info on",
    "info about",
    "details on",
    "details about",
    "tell me about",
    "give me information",
    "give me info",
    "give me details",
    "who is",
    "who's",
)

ANALYTICS_SIGNALS = (
    "how many",
    "count",
    "top ",
    "average",
    "avg ",
    "chart",
    "graph",
    "sorted",
    " sort",
    "salary",
    "coordinator",
    "engineer",
    "analyst",
    "manager",
    "department",
    " from low",
    " from high",
    "high to low",
    "low to high",
    "show me their",
    "list ",
    "breakdown",
)


def _is_person_lookup(question: str) -> bool:
    q = _normalize(question)
    return any(phrase in q for phrase in PERSON_LOOKUP_PHRASES)


def _extract_followup_person_term(question: str) -> str | None:
    q = question.strip().rstrip("?.!")
    patterns = (
        r"(?i)^what about\s+(.+)",
        r"(?i)^how about\s+(.+)",
        r"(?i)^and\s+(.+)",
        r"(?i)^same for\s+(.+)",
        r"(?i)^what of\s+(.+)",
    )
    for pattern in patterns:
        match = re.match(pattern, q)
        if match:
            return match.group(1).strip()
    return None


def _recent_person_context(history: list[dict]) -> bool:
    if not history:
        return False
    last = history[-1]
    if last.get("role") != "assistant":
        return False
    content = last.get("content", "")
    return content.startswith("Information for ") or DISAMBIGUATION_MARKER in content


def _looks_like_name_only(question: str) -> bool:
    q = question.strip().rstrip("?.!")
    if not q or len(q.split()) > 4:
        return False
    if _extract_followup_person_term(question):
        return False
    normalized = _normalize(q)
    if any(signal in normalized for signal in ANALYTICS_SIGNALS):
        return False
    blocked_prefixes = ("what ", "how ", "who ", "why ", "when ", "where ", "and ", "the ")
    if normalized.startswith(blocked_prefixes):
        return False
    words = q.replace(".", " ").replace(",", " ").split()
    return bool(words) and all(word.isalpha() or word.replace(".", "").isalpha() for word in words)


def _extract_person_term(question: str) -> str | None:
    patterns = (
        r"(?i)give me (?:information|info|details)(?:\s+on|\s+about|\s+for)?\s+(.+)",
        r"(?i)(?:information|info|details)(?:\s+on|\s+about|\s+for)\s+(.+)",
        r"(?i)tell me about\s+(.+)",
        r"(?i)who(?:'s| is)\s+(.+)",
    )
    for pattern in patterns:
        match = re.search(pattern, question.strip())
        if match:
            return match.group(1).strip().rstrip("?.!")
    return None


def _person_table(df: pd.DataFrame, person_name: str) -> ChatAnswer:
    return _table_answer(df, f"Information for {person_name}", "show me")


def _disambiguation_answer(
    matches: pd.DataFrame,
    name_col: str,
    label: str | None = None,
) -> ChatAnswer:
    names = matches[name_col].astype(str).tolist()
    first_name = (label or names[0].split()[0]).title()
    lines = [
        f"I found {len(names)} people named {first_name}. Which one do you mean?",
    ]
    for index, name in enumerate(names, start=1):
        lines.append(f"{index}. {name}")
    lines.append("Reply with the full name or number.")
    return ChatAnswer(type="text", text="\n".join(lines))


def _lookup_person_by_term(term: str, df: pd.DataFrame) -> ChatAnswer:
    name_col = _find_name_column(df)
    if not name_col:
        return ChatAnswer(type="text", text="No name column found in the dataset.")

    names = df[name_col].astype(str)
    term_norm = _normalize(term)

    exact = df[names.str.lower() == term_norm]
    if len(exact) == 1:
        return _person_table(exact, str(exact.iloc[0][name_col]))

    if term_norm.split():
        word_pattern = r"\b" + r"\s+".join(re.escape(word) for word in term_norm.split()) + r"\b"
        contains = df[names.str.lower().str.contains(word_pattern, regex=True, na=False)]
    else:
        contains = df[names.str.lower().str.contains(re.escape(term_norm), regex=True, na=False)]

    if len(contains) == 1:
        return _person_table(contains, str(contains.iloc[0][name_col]))

    if len(contains) > 1:
        return _disambiguation_answer(contains, name_col, term_norm.split()[0])

    term_first = term_norm.split()[0]
    first_matches = df[names.apply(lambda name: _normalize(name).split()[0] == term_first if name else False)]
    if first_matches.empty:
        return ChatAnswer(type="text", text=f"No person found matching '{term}'.")

    if len(first_matches) == 1:
        return _person_table(first_matches, str(first_matches.iloc[0][name_col]))

    return _disambiguation_answer(first_matches, name_col, term_first)


def _try_disambiguation_followup(
    question: str,
    history: list[dict],
    df: pd.DataFrame,
) -> ChatAnswer | None:
    if not history:
        return None

    last = history[-1]
    if last.get("role") != "assistant":
        return None
    content = last.get("content", "")
    if DISAMBIGUATION_MARKER not in content:
        return None

    options = re.findall(r"^\d+\.\s+(.+)$", content, flags=re.MULTILINE)
    if not options:
        return None

    selection = question.strip().rstrip("?.!")
    if selection.isdigit():
        index = int(selection) - 1
        if 0 <= index < len(options):
            return _lookup_person_by_term(options[index], df)

    selection_norm = _normalize(selection)
    for option in options:
        if selection_norm == _normalize(option):
            return _lookup_person_by_term(option, df)
        if selection_norm in _normalize(option):
            return _lookup_person_by_term(option, df)

    return ChatAnswer(
        type="text",
        text="Please reply with the full name or the number from the list.",
    )


def _try_person_lookup(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    history = history or []

    followup = _try_disambiguation_followup(question, history, df)
    if followup:
        return followup

    term: str | None = _extract_followup_person_term(question)
    if term:
        return _lookup_person_by_term(term, df)

    if _recent_person_context(history) and _looks_like_name_only(question):
        return _lookup_person_by_term(question.strip().rstrip("?.!"), df)

    if _is_person_lookup(question):
        term = _extract_person_term(question)
    elif _looks_like_name_only(question):
        term = question.strip().rstrip("?.!")

    if not term:
        return None

    return _lookup_person_by_term(term, df)


def _sort_ascending(question: str) -> bool:
    q = _normalize(question)
    if any(phrase in q for phrase in ("low to high", "lowest to highest", "ascending", "from low to high")):
        return True
    if any(phrase in q for phrase in ("high to low", "highest to lowest", "descending", "from high to low")):
        return False
    if any(word in q for word in ("lowest", "minimum", "min", "smallest", "bottom")):
        return True
    if any(word in q for word in ("highest", "maximum", "max", "largest", "top")):
        return False
    return False


def _result_limit(question: str, *, default: int = 5) -> int | None:
    match = TOP_N.search(question)
    if match:
        return int(match.group(1))
    q = _normalize(question)
    if any(word in q for word in ("top", "bottom")):
        return default
    return None


def _df_to_rows(df: pd.DataFrame) -> tuple[list[str], list[list[Any]]]:
    columns = [str(c) for c in df.columns.tolist()]
    rows = df.fillna("").astype(str).values.tolist()
    return columns, rows


def _table_answer(
    df: pd.DataFrame,
    title: str,
    question: str,
    label_col: str | None = None,
    value_col: str | None = None,
) -> ChatAnswer:
    columns, rows = _df_to_rows(df)
    chart = None
    response_type: str = "table" if len(df) >= 1 else "text"

    if _wants_chart(question) and label_col and value_col:
        labels = df[label_col].astype(str).tolist()
        values = pd.to_numeric(df[value_col], errors="coerce").fillna(0).tolist()
        chart = {
            "kind": "bar",
            "labels": labels,
            "label": str(value_col),
            "values": values,
        }
        response_type = "chart"

    text = title
    if response_type == "text" and rows:
        text = title + "\n" + "\n".join(
            ", ".join(f"{columns[i]}: {row[i]}" for i in range(len(columns))) for row in rows
        )

    return ChatAnswer(
        type=response_type,  # type: ignore[arg-type]
        text=text,
        columns=columns,
        rows=rows,
        chart=chart,
    )


def try_analytics_answer(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    q = _normalize(question)

    person_answer = _try_person_lookup(question, df, history)
    if person_answer:
        return person_answer

    group_term = _group_term(question)
    filter_match = _find_categorical_filter(question, df)
    is_aggregation_by = group_term and any(
        word in q for word in ("average", "avg", "mean", "per", "group", "breakdown")
    )
    if filter_match and not is_aggregation_by:
        filter_col, filter_value = filter_match
        return _filter_answer(question, df, filter_col, filter_value)

    if COUNT_QUESTION.search(q):
        letter_match = STARTS_WITH.search(question)
        if letter_match:
            name_col = _find_name_column(df)
            if name_col:
                letter = letter_match.group(1).lower()
                filtered = df[df[name_col].astype(str).str.lower().str.startswith(letter)]
                names = filtered[name_col].astype(str).tolist()
                if not names:
                    return ChatAnswer(
                        type="text",
                        text=f"0 people have names starting with '{letter.upper()}'.",
                    )
                preview = ", ".join(names[:8])
                suffix = f": {preview}" if len(names) <= 8 else f" (e.g. {', '.join(names[:5])}, ...)"
                return ChatAnswer(
                    type="text",
                    text=f"{len(names)} people have names starting with '{letter.upper()}'{suffix}.",
                )

        if not any(
            signal in q
            for signal in (
                "start with",
                "named",
                "where",
                "department",
                "city",
                "salary",
                "age",
                "top",
            )
        ):
            return ChatAnswer(type="text", text=f"There are {len(df)} records in the dataset.")

    exclude_terms = {group_term} if group_term else set()
    value_col = _find_column(question, df, exclude_terms=exclude_terms)
    if value_col and pd.api.types.is_numeric_dtype(df[value_col]):
        if any(
            word in q
            for word in ("top", "highest", "lowest", "bottom", "maximum", "minimum", "sort", "rank", "order")
        ):
            ascending = _sort_ascending(question)
            result = df.sort_values(value_col, ascending=ascending)
            limit = _result_limit(question)
            if limit is not None:
                result = result.head(limit)
            direction = "low to high" if ascending else "high to low"
            if limit is not None:
                title = f"Top {len(result)} by {value_col} ({direction})"
            else:
                title = f"All records by {value_col} ({direction})"
            label_col = _find_name_column(df)
            return _table_answer(result, title, question, label_col, value_col)

    group_col = None
    if group_term:
        by_term = group_term
        for col in df.columns:
            if pd.api.types.is_numeric_dtype(df[col]):
                continue
            col_norm = str(col).lower().replace("_", " ")
            if by_term == col_norm:
                group_col = col
                break
        if not group_col:
            for col in df.columns:
                if pd.api.types.is_numeric_dtype(df[col]):
                    continue
                col_lower = str(col).lower()
                for hints in COLUMN_HINTS.values():
                    if any(hint == by_term for hint in hints) and any(h in col_lower for h in hints):
                        group_col = col
                        break
                if group_col:
                    break
    if not group_col:
        for col in df.columns:
            if _word_in_question(str(col), question) and not pd.api.types.is_numeric_dtype(df[col]):
                group_col = col
                break

    if group_col and value_col and pd.api.types.is_numeric_dtype(df[value_col]):
        if any(word in q for word in ("average", "avg", "mean", "by", "per", "group", "breakdown")):
            grouped = (
                df.groupby(group_col)[value_col]
                .mean()
                .reset_index()
                .sort_values(value_col, ascending=False)
            )
            grouped[value_col] = grouped[value_col].round(2)
            title = f"Average {value_col} by {group_col}"
            return _table_answer(grouped, title, question, group_col, value_col)

    if value_col and _wants_chart(question) and pd.api.types.is_numeric_dtype(df[value_col]):
        ascending = _sort_ascending(question)
        result = df.sort_values(value_col, ascending=ascending)
        limit = _result_limit(question, default=10)
        if limit is not None:
            result = result.head(limit)
        label_col = _find_name_column(df)
        title = f"{value_col} chart"
        return _table_answer(result, title, question, label_col, value_col)

    return None
