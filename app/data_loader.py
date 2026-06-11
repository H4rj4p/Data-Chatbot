from __future__ import annotations

from pathlib import Path

import pandas as pd
from numbers_parser import Document

from app.config import APP_SESSION_ID, DATA_FILE
from app.rag.ingest import chunk_text, extract_document
from app.rag.store import get_store

_state: dict[str, object] = {
    "mtime": None,
    "filename": DATA_FILE.name,
}


def get_dataframe_info() -> dict:
    path = DATA_FILE
    if not path.exists():
        return {
            "path": str(path),
            "loaded": False,
            "rows": 0,
            "columns": [],
            "modified_at": None,
        }

    stat = path.stat()
    df = _state.get("df")
    return {
        "path": str(path),
        "loaded": isinstance(df, pd.DataFrame) and not df.empty,
        "rows": len(df) if isinstance(df, pd.DataFrame) else 0,
        "columns": [str(c) for c in df.columns.tolist()] if isinstance(df, pd.DataFrame) else [],
        "modified_at": stat.st_mtime,
    }


def get_dataframe() -> pd.DataFrame | None:
    df = _state.get("df")
    return df if isinstance(df, pd.DataFrame) else None


def _coerce_numeric_columns(df: pd.DataFrame) -> pd.DataFrame:
    for col in df.columns:
        col_lower = str(col).lower()
        if any(key in col_lower for key in ("salary", "pay", "wage", "age", "year")):
            df[col] = pd.to_numeric(df[col], errors="coerce")
    return df


def _load_numbers(path: Path) -> pd.DataFrame:
    doc = Document(str(path))
    for sheet in doc.sheets:
        for table in sheet.tables:
            if table.num_rows < 2:
                continue
            rows = list(table.iter_rows())
            data = [[cell.value if cell.value is not None else "" for cell in row] for row in rows]
            header = [str(value).strip() for value in data[0]]
            body = data[1:]
            if not any(any(str(cell).strip() for cell in row) for row in body):
                continue
            df = pd.DataFrame(body, columns=header)
            return _coerce_numeric_columns(df)
    raise ValueError(f"No usable table found in {path.name}")


def _load_file(path: Path) -> pd.DataFrame:
    suffix = path.suffix.lower()
    if suffix == ".numbers":
        return _load_numbers(path)
    if suffix in {".csv", ".txt"}:
        df = pd.read_csv(path)
        return _coerce_numeric_columns(df)
    if suffix in {".xlsx", ".xls"}:
        df = pd.read_excel(path)
        return _coerce_numeric_columns(df)
    raise ValueError(f"Unsupported data file type: {suffix}")


def _index_dataframe(df: pd.DataFrame, filename: str) -> None:
    doc = extract_document("data.csv", df.to_csv(index=False).encode("utf-8"))
    chunks = chunk_text(doc.text, is_csv=True)
    store = get_store(APP_SESSION_ID)
    store.clear()
    store.add_document(filename, chunks, row_count=len(df))


def reload_data_if_changed() -> bool:
    path = DATA_FILE
    if not path.exists():
        _state["df"] = None
        _state["mtime"] = None
        return False

    mtime = path.stat().st_mtime
    if _state.get("mtime") == mtime and isinstance(_state.get("df"), pd.DataFrame):
        return True

    df = _load_file(path)
    _state["df"] = df
    _state["mtime"] = mtime
    _state["filename"] = path.name
    _index_dataframe(df, path.name)
    return True


def load_data_on_startup() -> None:
    reload_data_if_changed()
