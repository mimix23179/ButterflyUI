from __future__ import annotations

from dataclasses import dataclass

__all__ = ["Alignment"]


@dataclass(slots=True)
class Alignment:
    x: float = 0.0
    y: float = 0.0

    def to_json(self) -> dict[str, float]:
        return {"x": float(self.x), "y": float(self.y)}
