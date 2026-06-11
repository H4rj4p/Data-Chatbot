from __future__ import annotations

from typing import Any

import pandas as pd

from app.analytics.models import ChatAnswer

AGG_LABELS = {
    "mean": "Average",
    "sum": "Total",
    "count": "Count",
    "min": "Minimum",
    "max": "Maximum",
}


def _resolve_column(df: pd.DataFrame, name: str) -> str | None:
    if not name:
        return None
    target = str(name).lower().replace("_", " ")
    for col in df.columns:
        col_norm = str(col).lower().replace("_", " ")
        if col_norm == target:
            return col
    return None


def _apply_filters(df: pd.DataFrame, filters: list[dict]) -> pd.DataFrame:
    result = df.copy()
    for item in filters:
        col = _resolve_column(result, str(item.get("column", "")))
        if not col:
            continue
        operator = str(item.get("operator", "equals")).lower()
        value = item.get("value", "")
        if operator == "contains":
            series = result[col].astype(str)
            result = result[series.str.contains(str(value), case=False, na=False, regex=False)]
            continue

        numeric_series = pd.to_numeric(result[col], errors="coerce")
        try:
            numeric_value = float(value)
            if numeric_series.notna().any():
                result = result[numeric_series == numeric_value]
                continue
        except (TypeError, ValueError):
            pass

        series = result[col].astype(str)
        result = result[series.str.lower() == str(value).lower()]
    return result


def _find_name_column(df: pd.DataFrame) -> str | None:
    for col in df.columns:
        if "name" in str(col).lower():
            return col
    return str(df.columns[0]) if len(df.columns) else None


def _df_to_answer(
    frame: pd.DataFrame,
    title: str,
    *,
    select_columns: list[str] | None = None,
) -> ChatAnswer:
    if frame.empty:
        return ChatAnswer(type="text", text=f"No records found for {title}.")

    display = frame.copy()
    if select_columns:
        resolved = [_resolve_column(display, col) for col in select_columns]
        cols = [col for col in resolved if col and col in display.columns]
        if cols:
            display = display[cols]

    columns = [str(col) for col in display.columns.tolist()]
    rows = display.astype(object).where(pd.notnull(display), "").values.tolist()
    return ChatAnswer(type="table", text=title, columns=columns, rows=rows)


def _format_metric(value: Any) -> str:
    if isinstance(value, float):
        if value.is_integer():
            return f"{int(value)}"
        return f"{value:.2f}".rstrip("0").rstrip(".")
    return str(value)


def execute_plan(plan: dict[str, Any], df: pd.DataFrame) -> ChatAnswer | None:
    intent = str(plan.get("intent", "")).lower()
    if intent in {"", "unsupported"}:
        return None

    filters = plan.get("filters") or []
    if not isinstance(filters, list):
        filters = []

    scoped = _apply_filters(df, filters)
    title = str(plan.get("title") or "Results").strip()
    select_columns = plan.get("select_columns")
    if select_columns and not isinstance(select_columns, list):
        select_columns = None

    sort = plan.get("sort")
    if isinstance(sort, dict):
        sort_col = _resolve_column(scoped, str(sort.get("column", "")))
        if sort_col and sort_col in scoped.columns:
            scoped = scoped.sort_values(sort_col, ascending=bool(sort.get("ascending", True)))

    limit = plan.get("limit")
    if isinstance(limit, int) and limit > 0:
        scoped = scoped.head(limit)

    if intent == "person":
        name = str(plan.get("person_name", "")).strip()
        if not name:
            return None
        name_col = _find_name_column(scoped)
        if not name_col:
            return None
        matches = scoped[
            scoped[name_col].astype(str).str.contains(name, case=False, na=False, regex=False)
        ]
        if matches.empty:
            return ChatAnswer(type="text", text=f"No person found matching '{name}'.")
        if len(matches) > 1:
            first_word = name.split()[0]
            first_matches = matches[
                matches[name_col].astype(str).str.split().str[0].str.lower() == first_word.lower()
            ]
            if len(first_matches) == 1:
                matches = first_matches
        person_title = title or f"Information for {matches.iloc[0][name_col]}"
        return _df_to_answer(matches, person_title, select_columns=select_columns)

    if intent == "extremum":
        spec = plan.get("extremum")
        if not isinstance(spec, dict):
            return None
        col = _resolve_column(scoped, str(spec.get("column", "")))
        if not col or col not in scoped.columns or scoped.empty:
            return None
        direction = str(spec.get("direction", "max")).lower()
        if direction == "min":
            target = scoped[col].min()
            result = scoped[scoped[col] == target]
        else:
            target = scoped[col].max()
            result = scoped[scoped[col] == target]
        return _df_to_answer(result, title or f"Result by {col}", select_columns=select_columns)

    if intent == "aggregate":
        aggregations = plan.get("aggregations") or []
        if not isinstance(aggregations, list) or not aggregations:
            return None

        metrics: list[tuple[str, Any]] = []
        for item in aggregations:
            if not isinstance(item, dict):
                continue
            col = _resolve_column(scoped, str(item.get("column", "")))
            func = str(item.get("function", "mean")).lower()
            if not col or col not in scoped.columns:
                continue
            if func == "count":
                value = len(scoped)
                metrics.append((f"Count", value))
                continue
            if func in {"mean", "average", "avg"}:
                value = round(float(scoped[col].mean()), 2)
                metrics.append((f"Average {col}", value))
            elif func == "sum":
                value = round(float(scoped[col].sum()), 2)
                metrics.append((f"Total {col}", value))
            elif func in {"min", "max"}:
                series = scoped[col]
                value = round(float(series.min() if func == "min" else series.max()), 2)
                label = AGG_LABELS[func]
                metrics.append((f"{label} {col}", value))
            else:
                continue

        if not metrics:
            return None

        count = len(scoped)
        if len(metrics) == 1:
            label, value = metrics[0]
            return ChatAnswer(
                type="text",
                text=f"The {label} is {_format_metric(value)} ({count} people).",
            )

        rows = [[label, _format_metric(value)] for label, value in metrics]
        return ChatAnswer(
            type="table",
            text=f"{title} ({count})",
            columns=["Metric", "Value"],
            rows=rows,
        )

    if intent == "count":
        count = len(scoped)
        return ChatAnswer(type="text", text=f"There are {count} matching records.")

    if intent == "list":
        return _df_to_answer(scoped, title or f"Results ({len(scoped)})", select_columns=select_columns)

    return None
