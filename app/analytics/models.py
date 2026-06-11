from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any, Literal


@dataclass
class ChatAnswer:
    type: Literal["text", "table", "chart"]
    text: str
    columns: list[str] | None = None
    rows: list[list[Any]] | None = None
    chart: dict[str, Any] | None = None
    tables: list[dict[str, Any]] | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
