from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["TextStyle"]


@dataclass(slots=True)
class TextStyle:
    color: Any | None = None
    size: float | None = None
    weight: str | None = None
    font_family: str | None = None
    italic: bool | None = None

    def to_json(self) -> dict[str, Any]:
        out: dict[str, Any] = {}
        if self.color is not None:
            out["color"] = self.color
        if self.size is not None:
            out["size"] = float(self.size)
        if self.weight is not None:
            out["weight"] = self.weight
        if self.font_family is not None:
            out["font_family"] = self.font_family
        if self.italic is not None:
            out["italic"] = bool(self.italic)
        return out
