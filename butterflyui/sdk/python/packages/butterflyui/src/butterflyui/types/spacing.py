from __future__ import annotations

from dataclasses import dataclass

__all__ = ["EdgeInsets"]


@dataclass(slots=True)
class EdgeInsets:
    left: float = 0.0
    top: float = 0.0
    right: float = 0.0
    bottom: float = 0.0

    def to_json(self) -> dict[str, float]:
        return {
            "left": float(self.left),
            "top": float(self.top),
            "right": float(self.right),
            "bottom": float(self.bottom),
        }
