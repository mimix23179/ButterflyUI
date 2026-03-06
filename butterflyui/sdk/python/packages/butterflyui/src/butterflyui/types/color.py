from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["ColorRGBA", "normalize_color_value"]


@dataclass(slots=True)
class ColorRGBA:
    r: int
    g: int
    b: int
    a: float = 1.0

    def to_json(self) -> dict[str, Any]:
        return {"r": int(self.r), "g": int(self.g), "b": int(self.b), "a": float(self.a)}


def normalize_color_value(value: Any) -> Any:
    if isinstance(value, ColorRGBA):
        return value.to_json()
    return value
