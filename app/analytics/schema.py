from __future__ import annotations

import pandas as pd


def build_schema_summary(df: pd.DataFrame, *, max_values: int = 25) -> list[dict]:
    summary: list[dict] = []
    for col in df.columns:
        entry: dict = {"column": str(col)}
        if pd.api.types.is_numeric_dtype(df[col]):
            entry["type"] = "number"
            non_null = df[col].dropna()
            if not non_null.empty:
                entry["min"] = round(float(non_null.min()), 2)
                entry["max"] = round(float(non_null.max()), 2)
        else:
            entry["type"] = "text"
            values = sorted(df[col].dropna().astype(str).unique().tolist())
            entry["values"] = values[:max_values]
            if len(values) > max_values:
                entry["values_truncated"] = True
        summary.append(entry)
    return summary
