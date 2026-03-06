from __future__ import annotations

from dataclasses import dataclass

__all__ = ["PointerEvent"]


@dataclass(slots=True)
class PointerEvent:
    x: float | None = None
    y: float | None = None
    button: str | None = None
    kind: str | None = None
