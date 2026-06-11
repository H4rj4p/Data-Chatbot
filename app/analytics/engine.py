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
    "salary": ("salary", "pay", "wage", "compensation", "income", "make", "earn", "paid"),
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


def _hint_in_question(hint: str, question: str) -> bool:
    if _word_in_question(hint, question):
        return True
    for word in _normalize(question).split():
        if len(word) >= 3 and _fuzzy_word_match(hint, word):
            return True
    return False


def _column_mentioned(question: str, col: str) -> bool:
    col_norm = str(col).lower().replace("_", " ")
    if _word_in_question(col_norm, question) or _hint_in_question(col_norm, question):
        return True
    col_lower = str(col).lower()
    for key, hints in COLUMN_HINTS.items():
        if key in col_lower:
            for hint in hints:
                if _hint_in_question(hint, question):
                    return True
    return False


def _wants_chart(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in CHART_WORDS)


def _wants_table(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in TABLE_WORDS) or bool(TOP_N.search(q))


GROUP_TERM_HINTS: dict[str, tuple[str, ...]] = {
    "job": ("role", "job", "title", "position"),
    "role": ("role", "job", "title"),
    "title": ("role", "job", "title"),
    "position": ("role", "job", "title"),
    "department": ("department", "dept", "team", "role"),
}


def _group_term(question: str) -> str | None:
    q = _normalize(question)
    if _wants_sort(question):
        return None

    per_match = re.search(r"\b(?:per|by|for each|each)\s+([a-z][a-z0-9_ ]*?)(?:\s*$)", q)
    if per_match:
        return per_match.group(1).strip()

    agg_match = re.search(
        r"\b(?:average|avg|mean|group|breakdown|per)\s+[\w ]+?\s+by\s+([a-z][a-z0-9_ ]*?)(?:\s|$)",
        q,
    )
    if agg_match:
        return agg_match.group(1).strip()

    match = re.search(r"\bby\s+([a-z][a-z0-9_ ]*?)(?:\s|$)", q)
    return match.group(1).strip() if match else None


def _resolve_group_column(term: str, df: pd.DataFrame) -> str | None:
    term_norm = term.lower().strip()
    for col in df.columns:
        if pd.api.types.is_numeric_dtype(df[col]):
            continue
        col_norm = str(col).lower().replace("_", " ")
        if term_norm == col_norm or _term_matches_column(term_norm, col):
            return col
    for col in df.columns:
        if pd.api.types.is_numeric_dtype(df[col]):
            continue
        col_lower = str(col).lower()
        hints = GROUP_TERM_HINTS.get(term_norm, (term_norm,))
        if any(hint in col_lower for hint in hints):
            return col
    return None


def _wants_average(question: str) -> bool:
    q = _normalize(question)
    if any(
        phrase in q
        for phrase in (
            "average",
            "avg ",
            "avg.",
            "mean ",
            "calculate average",
            "calculate the average",
        )
    ):
        return True
    if q.startswith("avg ") or " avg " in q:
        return True
    return any(_fuzzy_word_match("average", word) or word == "mean" for word in q.split())


def _wants_sum(question: str) -> bool:
    q = _normalize(question)
    if any(phrase in q for phrase in ("total number", "number of", "how many")):
        return False
    if re.search(r"\b(sum|combined)\b", q):
        return True
    if re.search(r"\btotal\b", q) and not re.search(r"\btotal\s+number\b", q):
        for hint in COLUMN_HINTS.get("salary", ()) + COLUMN_HINTS.get("age", ()):
            if _hint_in_question(hint, question):
                return True
    return False


def _aggregation_types(question: str) -> list[str]:
    types: list[str] = []
    if _wants_average(question):
        types.append("average")
    if _wants_sum(question):
        types.append("sum")
    return types


def _aggregation_label(value_col: str, agg_type: str) -> str:
    if agg_type == "average":
        return f"Average {value_col}"
    return f"Total {value_col}"


def _compute_aggregations(
    filtered: pd.DataFrame,
    value_col: str,
    agg_types: list[str],
) -> list[tuple[str, float]]:
    results: list[tuple[str, float]] = []
    for agg_type in agg_types:
        if agg_type == "average":
            value = round(float(filtered[value_col].mean()), 2)
        else:
            value = round(float(filtered[value_col].sum()), 2)
        results.append((_aggregation_label(value_col, agg_type), value))
    return results


def _format_aggregation_answer(
    label: str,
    count: int,
    results: list[tuple[str, float]],
) -> ChatAnswer:
    if len(results) == 1:
        metric, value = results[0]
        return ChatAnswer(
            type="text",
            text=f"The {metric} for {label} is {value} ({count} people).",
        )

    rows = [[metric, value] for metric, value in results]
    return ChatAnswer(
        type="table",
        text=f"{label} ({count})",
        columns=["Metric", "Value"],
        rows=rows,
    )


def _try_aggregation_answer(question: str, df: pd.DataFrame) -> ChatAnswer | None:
    agg_types = _aggregation_types(question)
    if not agg_types:
        return None

    filter_match = _find_categorical_filter(question, df)
    group_term = _group_term(question)
    exclude_terms: set[str] = set()
    if group_term:
        exclude_terms.add(group_term)
    if filter_match:
        exclude_terms.add(filter_match[1].lower())

    value_col = _find_column(question, df, exclude_terms=exclude_terms)
    if not value_col or not pd.api.types.is_numeric_dtype(df[value_col]):
        return None

    scoped, label, has_filter = _build_scoped_dataframe(question, df)
    if has_filter:
        count = len(scoped)
        if count == 0:
            return ChatAnswer(type="text", text=f"No records found matching {label}.")
        results = _compute_aggregations(scoped, value_col, agg_types)
        return _format_aggregation_answer(label, count, results)

    if filter_match and not group_term:
        filter_col, filter_value = filter_match
        filtered = df[df[filter_col].astype(str).str.lower() == filter_value.lower()]
        if filtered.empty:
            return ChatAnswer(type="text", text=f"No {filter_value} records found.")
        count = len(filtered)
        label = filter_value if count == 1 else f"{filter_value}s"
        results = _compute_aggregations(filtered, value_col, agg_types)
        return _format_aggregation_answer(label, count, results)

    group_col = _resolve_group_column(group_term, df) if group_term else None
    if group_col and agg_types == ["average"]:
        grouped = (
            df.groupby(group_col)[value_col]
            .mean()
            .reset_index()
            .sort_values(value_col, ascending=False)
        )
        grouped[value_col] = grouped[value_col].round(2)
        title = f"Average {value_col} by {group_col}"
        return _table_answer(grouped, title, question, group_col, value_col)

    count = len(df)
    results = _compute_aggregations(df, value_col, agg_types)
    if len(results) == 1 and results[0][0].startswith("Average"):
        metric, value = results[0]
        return ChatAnswer(
            type="text",
            text=f"The average {value_col} is {value} across {count} people.",
        )
    return _format_aggregation_answer(f"all {count} people", count, results)


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


def _parse_money_amount(question: str) -> float | None:
    match = re.search(r"\$?\s*(\d+(?:\.\d+)?)\s*([kKmM])\b", question)
    if match:
        amount = float(match.group(1))
        suffix = match.group(2).lower()
        return amount * (1000 if suffix == "k" else 1_000_000)

    match = re.search(r"\$\s*(\d{1,3}(?:,\d{3})+|\d+(?:\.\d+)?)\b", question)
    if match:
        return float(match.group(1).replace(",", ""))

    return None


def _wants_approximate(question: str) -> bool:
    q = _normalize(question)
    return any(
        word in q
        for word in ("about", "around", "approximately", "approx", "roughly", "near", "close to")
    )


def _salary_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        col_lower = str(col).lower()
        if "salary" in col_lower or "pay" in col_lower or "wage" in col_lower:
            return col
    return None


def _money_context(question: str) -> bool:
    q = _normalize(question)
    return any(
        word in q
        for word in ("make", "earn", "paid", "pay", "salary", "wage", "income", "compensation", "k")
    )


def _salary_filter_context(question: str) -> bool:
    q = _normalize(question)
    if re.search(r"\d+\s*[kKmM]\b", question):
        return True
    return bool(re.search(r"\b(?:make|earn|paid|pay|wage)\b", q))


def _age_filter_context(question: str) -> bool:
    q = _normalize(question)
    if re.search(r"\b(?:younger than|older than)\b", q):
        return True
    if re.search(r"\b(?:between|inbetween|in between)\b", q) and not re.search(
        r"\d+\s*[kKmM]\b", question
    ):
        return True
    if re.search(r"\b(?:years?\s+old|age\s+of)\b", q):
        return True
    if re.search(r"\b(?:over|under)\s+\d+\b", q) and not re.search(r"\d+\s*[kKmM]\b", question):
        return not _salary_filter_context(question)
    return False


def _resolve_filter_column(
    question: str,
    df: pd.DataFrame,
    *,
    values: list[float],
    has_k_suffix: bool = False,
    aggregate_col: str | None = None,
) -> str | None:
    age_col = _age_column(df)
    salary_col = _salary_column(df)

    if has_k_suffix or _salary_filter_context(question):
        return salary_col

    if _age_filter_context(question):
        return age_col

    if aggregate_col:
        agg_lower = aggregate_col.lower()
        if salary_col and ("salary" in agg_lower or "pay" in agg_lower) and age_col:
            if values and max(values) <= 120:
                return age_col
        if age_col and "age" in agg_lower and salary_col:
            return salary_col

    if values and max(values) <= 120:
        return age_col
    return salary_col


def _money_range(amount: float, *, approximate: bool) -> tuple[float, float]:
    if approximate or amount >= 1000:
        margin = max(amount * 0.1, 5000) if approximate else max(amount * 0.05, 2500)
        return amount - margin, amount + margin
    margin = max(amount * 0.1, 1)
    return amount - margin, amount + margin


def _format_money(value: float) -> str:
    if value >= 1000 and float(value).is_integer() and value % 1000 == 0:
        return f"${int(value / 1000)}k"
    if float(value).is_integer():
        return f"${int(value):,}"
    return f"${value:,.2f}"


def _find_numeric_filter(question: str, df: pd.DataFrame) -> tuple[str, float] | None:
    query = _find_numeric_query(question, df)
    if not query:
        return None
    col, low, high = query
    if low == high:
        return col, low
    return None


def _age_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        if "age" in str(col).lower():
            return col
    return None


def _location_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        col_lower = str(col).lower()
        if any(hint in col_lower for hint in ("location", "city", "office")):
            return col
    return None


def _dataset_size_numbers(question: str) -> set[float]:
    q = _normalize(question)
    sizes: set[float] = set()
    patterns = (
        r"\b(?:all\s+)?(\d+(?:\.\d+)?)\s+people\b",
        r"\bacross\s+(\d+(?:\.\d+)?)\s+people\b",
        r"\b(\d+(?:\.\d+)?)\s+(?:records|employees|rows)\b",
    )
    for pattern in patterns:
        for match in re.finditer(pattern, q):
            sizes.add(float(match.group(1)))
    return sizes


def _amount_from_match(number: str, suffix: str | None = None) -> float:
    amount = float(number)
    if suffix:
        suffix_lower = suffix.lower()
        if suffix_lower == "k":
            amount *= 1000
        elif suffix_lower == "m":
            amount *= 1_000_000
    return amount


def _age_related(question: str) -> bool:
    q = _normalize(question)
    return any(
        word in q
        for word in (
            "year",
            "years",
            "old",
            "age",
            "older",
            "younger",
            "elder",
            "over",
            "under",
        )
    )


def _comparison_patterns() -> list[tuple[str, str]]:
    return [
        (r"\b(?:more than|greater than|above|over|older than|at least)\b", "gt"),
        (r"\b(?:less than|fewer than|below|under|younger than|at most)\b", "lt"),
    ]


def _find_numeric_conditions(
    question: str,
    df: pd.DataFrame,
    aggregate_col: str | None = None,
) -> list[tuple[str, str, float, float | None]]:
    q = _normalize(question)
    conditions: list[tuple[str, str, float, float | None]] = []
    age_col = _age_column(df)
    salary_col = _salary_column(df)

    between = re.search(
        r"\b(?:between|in between|inbetween)\s+(\d+(?:\.\d+)?)\s*([kKmM])?\s+and\s+(\d+(?:\.\d+)?)\s*([kKmM])?",
        q,
    )
    if between:
        low = _amount_from_match(between.group(1), between.group(2))
        high = _amount_from_match(between.group(3), between.group(4))
        has_k = bool(between.group(2) or between.group(4))
        col = _resolve_filter_column(
            question,
            df,
            values=[low, high],
            has_k_suffix=has_k,
            aggregate_col=aggregate_col,
        )
        if col:
            conditions.append((col, "range", min(low, high), max(low, high)))
        return conditions

    for pattern, op in _comparison_patterns():
        match = re.search(
            pattern + r"\s+\$?(\d+(?:\.\d+)?)\s*([kKmM])?",
            q,
        )
        if match:
            value = _amount_from_match(match.group(1), match.group(2))
            col = _resolve_filter_column(
                question,
                df,
                values=[value],
                has_k_suffix=bool(match.group(2)),
                aggregate_col=aggregate_col,
            )
            if col:
                conditions.append((col, op, value, None))
            return conditions

    years_old = re.search(r"\b(\d+(?:\.\d+)?)\s*years?\s*old\b", q)
    if years_old and age_col:
        age = float(years_old.group(1))
        conditions.append((age_col, "eq", age, None))
        return conditions

    age_of = re.search(r"\bage\s+(?:of\s+)?(\d+(?:\.\d+)?)\b", q)
    if age_of and age_col:
        age = float(age_of.group(1))
        conditions.append((age_col, "eq", age, None))
        return conditions

    are_age = re.search(r"\bare\s+(\d+(?:\.\d+)?)\s*(?:years?\s*old)?\b", q)
    if are_age and age_col and any(
        word in q for word in ("people", "person", "employee", "years", "old")
    ):
        age = float(are_age.group(1))
        conditions.append((age_col, "eq", age, None))
        return conditions

    money_amount = _parse_money_amount(question)
    if (
        money_amount is not None
        and _salary_filter_context(question)
        and salary_col
        and not _age_filter_context(question)
    ):
        if _wants_approximate(question) or re.search(r"\d+\s*[kKmM]\b", question):
            low, high = _money_range(money_amount, approximate=_wants_approximate(question))
            conditions.append((salary_col, "range", low, high))
        else:
            conditions.append((salary_col, "eq", money_amount, None))
        return conditions

    excluded_sizes = _dataset_size_numbers(question)
    for col in df.columns:
        if not pd.api.types.is_numeric_dtype(df[col]):
            continue
        if not _column_mentioned(question, col):
            continue
        numbers = [
            float(number)
            for number in re.findall(r"\b(\d+(?:\.\d+)?)\b", q)
            if float(number) not in excluded_sizes
        ]
        if numbers:
            value = numbers[-1]
            conditions.append((col, "eq", value, None))
            return conditions

    return conditions


def _find_numeric_query(
    question: str,
    df: pd.DataFrame,
) -> tuple[str, float, float] | None:
    conditions = _find_numeric_conditions(question, df)
    if not conditions:
        return None
    col, op, v1, v2 = conditions[0]
    if op == "range" and v2 is not None:
        return col, v1, v2
    if op == "eq":
        return col, v1, v1
    if op == "gt":
        return col, v1 + 0.01, float("inf")
    if op == "lt":
        return col, float("-inf"), v1 - 0.01
    return None


def _find_location_filter(question: str, df: pd.DataFrame) -> tuple[str, str] | None:
    loc_col = _location_column(df)
    if not loc_col:
        return None

    q = _normalize(question.strip().rstrip("?.!"))
    patterns = (
        r"\bhow many\s+(?:people\s+)?(?:in|from|live in|located in)\s+(.+)$",
        r"\b(?:people|employees|everyone|who)\s+(?:in|from|live in|located in)\s+(.+)$",
        r"\b(?:in|live in|located in|from|based in)\s+(.+)$",
    )
    place: str | None = None
    for pattern in patterns:
        match = re.search(pattern, q)
        if match:
            place = match.group(1).strip()
            break
    if not place:
        return None

    place = re.sub(r"\s+(are|who|with|that|make|named)\b.*$", "", place).strip()
    place_norm = _normalize(place)

    for value in df[loc_col].dropna().astype(str).unique():
        value_norm = _normalize(value)
        city = value_norm.split(",")[0].strip()
        if place_norm in {value_norm, city} or place_norm in value_norm:
            return loc_col, value
    return None


def _apply_numeric_condition(
    frame: pd.DataFrame,
    col: str,
    op: str,
    value1: float,
    value2: float | None,
) -> pd.DataFrame:
    series = pd.to_numeric(frame[col], errors="coerce")
    if op == "eq":
        return frame[series == value1]
    if op == "range" and value2 is not None:
        return frame[(series >= value1) & (series <= value2)]
    if op == "gt":
        return frame[series > value1]
    if op == "lt":
        return frame[series < value1]
    return frame


def _condition_label(
    col: str,
    op: str,
    value1: float,
    value2: float | None,
    question: str,
) -> str:
    is_money = "salary" in col.lower() or "pay" in col.lower() or _salary_filter_context(question)
    if op == "eq" and ("year" in _normalize(question) or "age" in col.lower()):
        return f"age {_format_number(value1)}"
    if op == "range" and value2 is not None and is_money:
        return f"about {_format_money((value1 + value2) / 2)}"
    if op == "range" and value2 is not None:
        return f"{col} {_format_number(value1)}-{_format_number(value2)}"
    if op == "gt" and is_money:
        return f"over {_format_money(value1)}"
    if op == "lt" and is_money:
        return f"under {_format_money(value1)}"
    if op == "gt":
        return f"over {_format_number(value1)}"
    if op == "lt":
        return f"under {_format_number(value1)}"
    if is_money:
        return _format_money(value1)
    return f"{col} {_format_number(value1)}"


def _uses_context_count_followup(question: str) -> bool:
    q = _normalize(question)
    return q in {
        "how many are there",
        "how many total",
        "how many in total",
        "what is the count",
    } or bool(re.search(r"\bhow many (?:are )?there\b", q))


def _is_filter_query(question: str, df: pd.DataFrame) -> bool:
    q = _normalize(question)
    if _find_location_filter(question, df):
        return True
    if _find_numeric_conditions(question, df):
        return True
    if re.search(
        r"\b(?:older than|younger than|more than|less than|between|inbetween|in between|named)\b",
        q,
    ):
        return True
    return False


def _question_has_self_filters(question: str, df: pd.DataFrame) -> bool:
    _, _, has_filter = _build_scoped_dataframe(question, df)
    return has_filter


def _wants_count_and_list(question: str) -> bool:
    q = _normalize(question)
    has_count = bool(COUNT_QUESTION.search(q))
    has_list = bool(re.search(r"\b(?:list|show|display)\b", q))
    return has_count and has_list


def _scoped_aggregate_column(question: str, df: pd.DataFrame) -> str | None:
    if not (_aggregation_types(question) or _wants_average(question)):
        return None
    exclude: set[str] = set()
    filter_match = _find_categorical_filter(question, df)
    if filter_match:
        exclude.add(filter_match[1].lower())
    return _find_column(question, df, exclude_terms=exclude)


def _build_scoped_dataframe(
    question: str,
    df: pd.DataFrame,
) -> tuple[pd.DataFrame, str, bool]:
    scoped = df.copy()
    labels: list[str] = []
    has_filter = False
    aggregate_col = _scoped_aggregate_column(question, df)

    filter_match = _find_categorical_filter(question, df)
    if filter_match:
        filter_col, filter_value = filter_match
        scoped = scoped[scoped[filter_col].astype(str).str.lower() == filter_value.lower()]
        labels.append(filter_value if len(scoped) == 1 else f"{filter_value}s")
        has_filter = True

    location_match = _find_location_filter(question, df)
    if location_match:
        loc_col, loc_value = location_match
        scoped = scoped[
            scoped[loc_col].astype(str).str.contains(loc_value, case=False, na=False, regex=False)
        ]
        labels.append(loc_value)
        has_filter = True

    for col, op, value1, value2 in _find_numeric_conditions(question, df, aggregate_col):
        scoped = _apply_numeric_condition(scoped, col, op, value1, value2)
        labels.append(_condition_label(col, op, value1, value2, question))
        has_filter = True

    named_match = re.search(r"\bnamed\s+(.+?)(?:\?|$)", _normalize(question))
    if named_match:
        name_col = _find_name_column(df)
        if name_col:
            term = named_match.group(1).strip()
            scoped = scoped[
                scoped[name_col].astype(str).str.contains(term, case=False, na=False, regex=False)
            ]
            labels.append(f"named {term}")
            has_filter = True

    label = " + ".join(labels) if labels else "matching"
    return scoped, label, has_filter


def _wants_scoped_list(question: str) -> bool:
    q = _normalize(question)
    if _wants_count_and_list(question):
        return True
    if COUNT_QUESTION.search(q) and not _uses_context_count_followup(question):
        return False
    return bool(
        re.search(r"\b(?:who|which|show|list|display|everyone)\b", q)
        or q.startswith("people ")
        or "people who" in q
        or q.startswith("employees ")
    )


def _format_scoped_count(count: int, label: str, question: str) -> str:
    q = _normalize(question)
    if "year" in q or "old" in q:
        if count == 1:
            return f"There is 1 person in {label}."
        return f"There are {count} people in {label}."
    if _money_context(question):
        if count == 1:
            return f"There is 1 person who matches {label}."
        return f"There are {count} people who match {label}."
    if count == 1:
        return f"There is 1 person matching {label}."
    return f"There are {count} people matching {label}."


def _try_scoped_query_answer(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    del history
    if _aggregation_types(question):
        return None

    scoped, label, has_filter = _build_scoped_dataframe(question, df)
    if not has_filter:
        return None

    q = _normalize(question)
    wants_count = bool(COUNT_QUESTION.search(q)) or _uses_context_count_followup(question)
    wants_list = _wants_scoped_list(question)

    if wants_count and wants_list:
        count = len(scoped)
        if scoped.empty:
            return ChatAnswer(type="text", text=f"No people found for {label}.")
        columns, rows = _df_to_rows(scoped)
        return ChatAnswer(
            type="table",
            text=_format_scoped_count(count, label, question),
            columns=columns,
            rows=rows,
        )

    if wants_count:
        count = len(scoped)
        return ChatAnswer(type="text", text=_format_scoped_count(count, label, question))

    if wants_list or _is_filter_query(question, df):
        if scoped.empty:
            return ChatAnswer(type="text", text=f"No people found for {label}.")
        if label != "matching":
            title = f"People matching {label} ({len(scoped)})"
        else:
            title = f"Results ({len(scoped)})"
        return _table_answer(scoped, title, question)

    return None


def _format_number(value: float) -> str:
    if float(value).is_integer():
        return str(int(value))
    return str(value)


def _is_total_dataset_count_question(question: str) -> bool:
    q = _normalize(question.strip().rstrip("?.!"))
    return q in {
        "how many",
        "how many people",
        "how many records",
        "how many employees",
        "how many people are there",
        "how many are in the dataset",
        "total number",
        "count",
        "how many total",
    }


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
                if key in col_lower and any(_hint_in_question(hint, question) for hint in hints):
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

CHITCHAT_WORDS = frozenset({
    "hi",
    "hello",
    "hey",
    "hiya",
    "yo",
    "sup",
    "thanks",
    "thank",
    "thx",
    "ty",
    "ok",
    "okay",
    "yes",
    "no",
    "yeah",
    "yep",
    "nope",
    "bye",
    "goodbye",
    "help",
    "please",
})

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


def _is_chitchat(question: str) -> bool:
    normalized = _normalize(question.strip().rstrip("?.!"))
    if normalized in CHITCHAT_WORDS:
        return True
    return normalized.startswith(("hi ", "hello ", "hey ", "thanks ", "thank you"))


def _try_greeting(question: str) -> ChatAnswer | None:
    if not _is_chitchat(question):
        return None
    return ChatAnswer(
        type="text",
        text=(
            "Hi! I can answer questions about your data file. "
            "Try: 'how many HR coordinators', 'information on Harjap', "
            "or 'top 5 salary high to low'."
        ),
    )


def _is_person_lookup(question: str) -> bool:
    q = _normalize(question)
    return any(phrase in q for phrase in PERSON_LOOKUP_PHRASES)


def _extract_followup_term(question: str) -> str | None:
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


def _extract_followup_person_term(question: str) -> str | None:
    return _extract_followup_term(question)


def _is_analytics_followup_term(term: str, df: pd.DataFrame) -> bool:
    if _aggregation_types(term):
        return True
    if _wants_sort(term):
        return True
    if _find_categorical_filter(term, df):
        return True

    q = _normalize(term)
    if any(signal in q for signal in ANALYTICS_SIGNALS):
        return True

    value_col = _find_column(term, df)
    return bool(value_col and pd.api.types.is_numeric_dtype(df[value_col]))


def _try_phrase_followup(question: str, df: pd.DataFrame) -> ChatAnswer | None:
    term = _extract_followup_term(question)
    if not term or not _is_analytics_followup_term(term, df):
        return None

    aggregation_answer = _try_aggregation_answer(term, df)
    if aggregation_answer:
        return aggregation_answer

    filter_match = _find_categorical_filter(term, df)
    if filter_match:
        filter_col, filter_value = filter_match
        return _filter_answer(term, df, filter_col, filter_value)

    return None


PRONOUN_FOLLOWUP = re.compile(r"\b(?:they|them|their|those|these|that)\b", re.IGNORECASE)

IDENTITY_FOLLOWUP = re.compile(
    r"(?i)\b(?:who is that|who's that|who are they|who is they|which one|who are those|"
    r"who is the one|that person|those people|and who)\b",
)


def _uses_pronoun_followup(question: str) -> bool:
    return bool(PRONOUN_FOLLOWUP.search(question))


def _is_identity_followup(question: str) -> bool:
    if IDENTITY_FOLLOWUP.search(question):
        return True
    q = _normalize(question)
    term = _extract_followup_term(question)
    if term:
        term_norm = _normalize(term)
        if re.search(r"\bwho\b", term_norm) and re.search(r"\b(?:that|they|them|those|one)\b", term_norm):
            return True
    return bool(re.search(r"\bwho\b", q) and re.search(r"\b(?:that|they|them|those|one)\b", q))


def _uses_context_followup(question: str, df: pd.DataFrame) -> bool:
    if _question_has_self_filters(question, df):
        return False
    return (
        _uses_pronoun_followup(question)
        or _is_identity_followup(question)
        or _uses_context_count_followup(question)
    )


def _label_to_filter(label: str, df: pd.DataFrame) -> tuple[str, str] | None:
    label_norm = _normalize(label).rstrip("s")
    best: tuple[str, str, int] | None = None
    for col in df.columns:
        if pd.api.types.is_numeric_dtype(df[col]):
            continue
        for value in df[col].dropna().astype(str).unique():
            value_norm = _normalize(value)
            if label_norm in {value_norm, f"{value_norm}s", value_norm.rstrip("s")}:
                return col, value
            if _value_matches_question(value, label):
                score = len(value_norm)
                if best is None or score > best[2]:
                    best = (col, value, score)
    if best is None:
        return None
    return best[0], best[1]


def _numeric_filter_from_history(
    history: list[dict],
    df: pd.DataFrame,
) -> tuple[str, float] | None:
    for msg in reversed(history[-6:]):
        content = msg.get("content", "")
        if msg.get("role") == "user":
            match = _find_numeric_query(content, df)
            if match:
                col, low, high = match
                return col, low if low == high else (low + high) / 2

        years_old = re.search(
            r"(?:who (?:is|are)|person who is|people who are)\s+(\d+(?:\.\d+)?)\s+years?\s+old",
            content,
            flags=re.IGNORECASE,
        )
        if years_old:
            for col in df.columns:
                if "age" in str(col).lower():
                    return col, float(years_old.group(1))

        with_value = re.search(
            r"with\s+(\w+)\s+of\s+(\d+(?:\.\d+)?)",
            content,
            flags=re.IGNORECASE,
        )
        if with_value:
            col = _resolve_column_name(df, with_value.group(1))
            if col:
                return col, float(with_value.group(2))
    return None


def _resolve_column_name(df: pd.DataFrame, name: str) -> str | None:
    target = str(name).lower().replace("_", " ")
    for col in df.columns:
        if str(col).lower().replace("_", " ") == target:
            return col
    return None


def _context_filter_from_history(
    history: list[dict],
    df: pd.DataFrame,
) -> tuple[str, str] | None:
    for msg in reversed(history[-6:]):
        content = msg.get("content", "")
        if msg.get("role") == "user":
            match = _find_categorical_filter(content, df)
            if match:
                return match

        title_match = re.match(r"^(.+?)\s+\(\d+\)", content)
        if title_match:
            match = _label_to_filter(title_match.group(1), df)
            if match:
                return match

        average_match = re.search(r"for (.+?) is ", content)
        if average_match:
            match = _label_to_filter(average_match.group(1), df)
            if match:
                return match

        sorted_match = re.match(r"^\d+ (.+?) sorted by ", content)
        if sorted_match:
            match = _label_to_filter(sorted_match.group(1), df)
            if match:
                return match
    return None


def _scope_from_question(question: str, df: pd.DataFrame) -> pd.DataFrame | None:
    scoped, _, has_filter = _build_scoped_dataframe(question, df)
    if has_filter:
        return scoped.copy()
    return None


def _context_scope_from_history(
    history: list[dict],
    df: pd.DataFrame,
) -> pd.DataFrame | None:
    for msg in reversed(history[-6:]):
        content = msg.get("content", "")
        if msg.get("role") == "user":
            scoped = _scope_from_question(content, df)
            if scoped is not None:
                return scoped

        money_about = re.search(
            r"make about (\$(\d+)k)",
            content,
            flags=re.IGNORECASE,
        )
        if money_about:
            salary_col = _salary_column(df)
            if salary_col:
                amount = float(money_about.group(1).replace("$", "").replace("k", "")) * 1000
                low, high = _money_range(amount, approximate=True)
                series = pd.to_numeric(df[salary_col], errors="coerce")
                scoped = df[(series >= low) & (series <= high)].copy()
                if not scoped.empty:
                    return scoped

    numeric_filter = _numeric_filter_from_history(history, df)
    if numeric_filter:
        col, value = numeric_filter
        series = pd.to_numeric(df[col], errors="coerce")
        scoped = df[series == value].copy()
        return scoped if not scoped.empty else None

    filter_match = _context_filter_from_history(history, df)
    if filter_match:
        filter_col, filter_value = filter_match
        scoped = df[df[filter_col].astype(str).str.lower() == filter_value.lower()].copy()
        return scoped if not scoped.empty else None

    return None


def _numeric_column_for_followup(question: str, df: pd.DataFrame) -> str | None:
    for col in df.columns:
        if pd.api.types.is_numeric_dtype(df[col]) and _column_mentioned(question, col):
            return col
    q = _normalize(question)
    if any(word in q for word in ("make", "earn", "paid", "salary", "pay", "wage")):
        for col in df.columns:
            if "salary" in str(col).lower() or "pay" in str(col).lower():
                return col
    if "age" in q or "old" in q:
        for col in df.columns:
            if "age" in str(col).lower():
                return col
    return None


def _try_context_followup(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    history = history or []
    if not history or not _uses_context_followup(question, df):
        return None

    filtered = _context_scope_from_history(history, df)
    if filtered is None or filtered.empty:
        return None

    count = len(filtered)
    name_col = _find_name_column(df)

    if _uses_context_count_followup(question):
        if count == 1:
            return ChatAnswer(type="text", text="There is 1 person in that group.")
        return ChatAnswer(type="text", text=f"There are {count} people in that group.")

    if _is_identity_followup(question):
        if count == 1 and name_col:
            person_name = str(filtered.iloc[0][name_col])
            return _table_answer(filtered, f"That person: {person_name}", question)
        return _table_answer(filtered, f"Those people ({count})", question)

    label = "those people"
    for msg in reversed(history[-6:]):
        if msg.get("role") == "user":
            _, hist_label, has_filter = _build_scoped_dataframe(msg.get("content", ""), df)
            if has_filter:
                label = hist_label
                break

    filter_match = _context_filter_from_history(history, df)
    if filter_match:
        filter_value = filter_match[1]
        label = filter_value if count == 1 else f"{filter_value}s"

    value_col = _numeric_column_for_followup(question, df)
    agg_types = _aggregation_types(question)

    if value_col and agg_types:
        results = _compute_aggregations(filtered, value_col, agg_types)
        return _format_aggregation_answer(label, count, results)

    if value_col:
        display_cols = list(dict.fromkeys([c for c in [name_col, value_col] if c and c in filtered.columns]))
        result = filtered[display_cols]
        title = f"{label} {value_col}"
        return _table_answer(result, title, question)

    if filter_match:
        return _filter_answer(question, df, filter_match[0], filter_match[1])

    return _table_answer(filtered, f"Those people ({count})", question)


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
    if not q or len(q.split()) > 2:
        return False
    if _is_chitchat(question):
        return False
    if _extract_followup_person_term(question):
        return False
    normalized = _normalize(q)
    if re.search(r"\b(?:in|at|from|with|for|near|on|located|sorted|average|total)\b", normalized):
        return False
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


MAX_EXTREMUM_WORDS = (
    "oldest",
    "eldest",
    "highest",
    "maximum",
    "greatest",
    "most paid",
    "highest paid",
    "earns the most",
    "earn the most",
    "top paid",
    "richest",
)

MIN_EXTREMUM_WORDS = (
    "youngest",
    "lowest",
    "minimum",
    "least paid",
    "lowest paid",
    "earns the least",
    "earn the least",
    "poorest",
)


def _extremum_direction(question: str) -> str | None:
    q = _normalize(question)
    min_hit = any(word in q for word in MIN_EXTREMUM_WORDS)
    max_hit = any(word in q for word in MAX_EXTREMUM_WORDS)
    if not max_hit and re.search(r"\bmost\b", q) and any(
        word in q for word in ("earn", "paid", "salary", "pay", "make")
    ):
        max_hit = True
    if min_hit and not max_hit:
        return "min"
    if max_hit and not min_hit:
        return "max"
    if re.search(r"\b(?:most|max|maximum|highest|top)\b", q):
        return "max"
    if re.search(r"\b(?:least|min|minimum|lowest|bottom)\b", q):
        return "min"
    return None


def _is_extremum_person_query(question: str) -> bool:
    if _extremum_direction(question) is None:
        return False
    q = _normalize(question)
    if re.search(r"\b(?:role|job|title|department|team)\b", q) and re.search(
        r"\b(?:average|avg|mean|per)\b", q
    ):
        return False
    return bool(re.search(r"\b(?:who|which)\b", q)) or "person" in q


def _extremum_value_column(question: str, df: pd.DataFrame) -> str | None:
    q = _normalize(question)
    explicit = _find_column(question, df)
    if explicit and pd.api.types.is_numeric_dtype(df[explicit]):
        return explicit

    if any(word in q for word in ("oldest", "youngest", "eldest", "age")):
        for col in df.columns:
            if "age" in str(col).lower():
                return col

    if any(
        word in q
        for word in ("salary", "pay", "paid", "earn", "make", "wage", "compensation", "income", "rich")
    ):
        for col in df.columns:
            col_lower = str(col).lower()
            if "salary" in col_lower or "pay" in col_lower:
                return col

    if any(word in q for word in ("oldest", "youngest", "eldest")):
        for col in df.columns:
            if "age" in str(col).lower():
                return col

    for col in df.columns:
        if "salary" in str(col).lower() or "pay" in str(col).lower():
            return col
    return None


def _extremum_label(value_col: str, direction: str) -> str:
    if "age" in value_col.lower():
        return "Oldest person" if direction == "max" else "Youngest person"
    if direction == "max":
        return f"Highest {value_col}"
    return f"Lowest {value_col}"


def _try_extremum_person(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    history = history or []
    if not _is_extremum_person_query(question):
        return None

    direction = _extremum_direction(question)
    value_col = _extremum_value_column(question, df)
    if not direction or not value_col:
        return None

    scoped = df.copy()
    if re.search(r"\bon the list\b", _normalize(question)):
        filter_match = _context_filter_from_history(history, df)
        if filter_match:
            filter_col, filter_value = filter_match
            scoped = scoped[
                scoped[filter_col].astype(str).str.lower() == filter_value.lower()
            ]

    if scoped.empty:
        return ChatAnswer(type="text", text="No matching records found.")

    if direction == "max":
        target_value = scoped[value_col].max()
        result = scoped[scoped[value_col] == target_value]
    else:
        target_value = scoped[value_col].min()
        result = scoped[scoped[value_col] == target_value]

    label = _extremum_label(value_col, direction)
    name_col = _find_name_column(df)
    if len(result) == 1 and name_col:
        person_name = str(result.iloc[0][name_col])
        title = f"{label}: {person_name}"
    else:
        title = f"{label} ({len(result)})"
    return _table_answer(result, title, question)


ORDINAL_INDEX: dict[str, int] = {
    "first": 0,
    "1st": 0,
    "one": 0,
    "second": 1,
    "2nd": 1,
    "two": 1,
    "third": 2,
    "3rd": 2,
    "three": 2,
    "fourth": 3,
    "4th": 3,
    "four": 3,
    "fifth": 4,
    "5th": 4,
    "five": 4,
}

ORDINAL_LABELS = ("first", "second", "third", "fourth", "fifth")


def _is_ordinal_person_query(question: str, history: list[dict] | None = None) -> bool:
    q = _normalize(question)
    if re.search(
        r"\b(?:first|last|second|third|fourth|fifth|\d+(?:st|nd|rd|th)?)\s+"
        r"(?:person|one|record|employee|row|entry)\b",
        q,
    ):
        return True
    if re.search(r"\b(?:who is|who's)\s+the\s+(?:first|last|second|third|fourth|fifth|\d+)\b", q):
        return True
    if re.search(r"\bthe\s+(?:first|last|second|third|fourth|fifth|\d+)\s+one\b", q):
        return True
    if re.search(r"\bperson\s+(?:number\s+)?#?\d+\b", q):
        return True
    if history and re.search(r"\b(?:the\s+)?(?:first|last)\s+one\b", q):
        return True
    return False


def _ordinal_index(question: str) -> int | None:
    q = _normalize(question)
    if re.search(r"\blast\b", q):
        return -1
    for word, index in ORDINAL_INDEX.items():
        if re.search(rf"\b{re.escape(word)}\b", q):
            return index
    number_match = re.search(r"\b(?:person\s+)?(?:number\s+)?#?(\d+)\b", q)
    if number_match:
        return int(number_match.group(1)) - 1
    return None


def _ordinal_position_label(index: int) -> str:
    if index < 0:
        return "Last"
    if index < len(ORDINAL_LABELS):
        return ORDINAL_LABELS[index].title()
    return f"#{index + 1}"


def _try_ordinal_person(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    history = history or []
    if not _is_ordinal_person_query(question, history):
        return None

    index = _ordinal_index(question)
    if index is None and re.search(r"\bfirst\s+one\b", _normalize(question)):
        index = 0
    if index is None and re.search(r"\blast\s+one\b", _normalize(question)):
        index = -1
    if index is None:
        return None

    if index < 0:
        if df.empty:
            return ChatAnswer(type="text", text="The list is empty.")
        row = df.iloc[[index]]
        label = "Last person on the list"
    else:
        if index >= len(df):
            return ChatAnswer(type="text", text=f"The list only has {len(df)} people.")
        row = df.iloc[[index]]
        label = f"{_ordinal_position_label(index)} person on the list"

    name_col = _find_name_column(df)
    person_name = str(row.iloc[0][name_col]) if name_col else label
    return _table_answer(row, f"{label}: {person_name}", question)


def _try_person_lookup(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    history = history or []

    followup = _try_disambiguation_followup(question, history, df)
    if followup:
        return followup

    if _uses_context_followup(question, df):
        return None

    if _is_filter_query(question, df):
        return None

    term: str | None = _extract_followup_person_term(question)
    if term:
        if _is_identity_followup(question) or _is_analytics_followup_term(term, df):
            return None
        return _lookup_person_by_term(term, df)

    if _recent_person_context(history) and _looks_like_name_only(question):
        return _lookup_person_by_term(question.strip().rstrip("?.!"), df)

    if _is_extremum_person_query(question):
        return None

    if _is_person_lookup(question) and not _is_ordinal_person_query(question, history):
        term = _extract_person_term(question)
    elif _looks_like_name_only(question):
        term = question.strip().rstrip("?.!")

    if not term:
        return None

    if _is_ordinal_person_query(term, history):
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

    greeting = _try_greeting(question)
    if greeting:
        return greeting

    ordinal_answer = _try_ordinal_person(question, df, history)
    if ordinal_answer:
        return ordinal_answer

    extremum_answer = _try_extremum_person(question, df, history)
    if extremum_answer:
        return extremum_answer

    phrase_followup = _try_phrase_followup(question, df)
    if phrase_followup:
        return phrase_followup

    context_answer = _try_context_followup(question, df, history)
    if context_answer:
        return context_answer

    aggregation_answer = _try_aggregation_answer(question, df)
    if aggregation_answer:
        return aggregation_answer

    scoped_answer = _try_scoped_query_answer(question, df, history)
    if scoped_answer:
        return scoped_answer

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

    if COUNT_QUESTION.search(q) or _uses_context_count_followup(question):
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

        if _is_total_dataset_count_question(question):
            return ChatAnswer(type="text", text=f"There are {len(df)} people in total.")

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
