from __future__ import annotations

from dataclasses import dataclass
from typing import Any

__all__ = ["BorderSideSpec", "BorderSpec"]


@dataclass(slots=True)
class BorderSideSpec:
    color: Any | None = None
    width: float | None = None

    def to_json(self) -> dict[str, Any]:
        out: dict[str, Any] = {}
        if self.color is not None:
            out["color"] = self.color
        if self.width is not None:
            out["width"] = float(self.width)
        return out


@dataclass(slots=True)
class BorderSpec:
    top: BorderSideSpec | None = None
    right: BorderSideSpec | None = None
    bottom: BorderSideSpec | None = None
    left: BorderSideSpec | None = None
    radius: float | None = None

    def to_json(self) -> dict[str, Any]:
        out: dict[str, Any] = {}
        if self.top is not None:
            out["top"] = self.top.to_json()
        if self.right is not None:
            out["right"] = self.right.to_json()
        if self.bottom is not None:
            out["bottom"] = self.bottom.to_json()
        if self.left is not None:
            out["left"] = self.left.to_json()
        if self.radius is not None:
            out["radius"] = float(self.radius)
        return out
