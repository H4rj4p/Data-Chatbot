from __future__ import annotations

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


def _wants_chart(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in CHART_WORDS)


def _wants_table(question: str) -> bool:
    q = _normalize(question)
    return any(word in q for word in TABLE_WORDS) or bool(TOP_N.search(q))


def _find_column(question: str, df: pd.DataFrame) -> str | None:
    q = _normalize(question)
    for col in df.columns:
        col_norm = str(col).lower().replace("_", " ")
        if col_norm in q or str(col).lower() in q:
            return col

    for col in df.columns:
        col_lower = str(col).lower()
        for key, hints in COLUMN_HINTS.items():
            if key in col_lower and any(hint in q for hint in hints):
                return col
    return None


def _find_name_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        if "name" in str(col).lower():
            return col
    return df.columns[0] if len(df.columns) else None


def _sort_ascending(question: str) -> bool:
    q = _normalize(question)
    if "highest to lowest" in q or "descending" in q:
        return False
    if "lowest to highest" in q or "ascending" in q:
        return True
    if any(word in q for word in ("lowest", "minimum", "min", "smallest", "bottom")):
        return True
    if any(word in q for word in ("highest", "maximum", "max", "largest", "top")):
        return False
    return False


def _result_n(question: str, default: int = 5) -> int:
    match = TOP_N.search(question)
    return int(match.group(1)) if match else default


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
    response_type: str = "table" if _wants_table(question) or len(df) > 1 else "text"

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


def try_analytics_answer(question: str, df: pd.DataFrame) -> ChatAnswer | None:
    q = _normalize(question)

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

    value_col = _find_column(question, df)
    if value_col and pd.api.types.is_numeric_dtype(df[value_col]):
        if any(word in q for word in ("top", "highest", "lowest", "bottom", "maximum", "minimum", "sort", "rank")):
            n = _result_n(question, default=5)
            ascending = _sort_ascending(question)
            result = df.sort_values(value_col, ascending=ascending).head(n)
            direction = "lowest" if ascending else "highest"
            title = f"Top {len(result)} by {value_col} ({direction} first)"
            label_col = _find_name_column(df)
            return _table_answer(result, title, question, label_col, value_col)

    group_col = None
    for col in df.columns:
        if str(col).lower() in q and not pd.api.types.is_numeric_dtype(df[col]):
            group_col = col
            break
    if not group_col:
        for col in df.columns:
            cl = str(col).lower()
            if "department" in cl and "department" in q:
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
        n = _result_n(question, default=10)
        ascending = _sort_ascending(question)
        result = df.sort_values(value_col, ascending=ascending).head(n)
        label_col = _find_name_column(df)
        title = f"{value_col} chart"
        return _table_answer(result, title, question, label_col, value_col)

    return None
