from __future__ import annotations

from typing import Any

from .control import Control

__all__ = ["LayoutControl"]


class LayoutControl(Control):
    """Shared layout behavior for visual ButterflyUI controls."""

    @property
    def left(self) -> float | None:
        value = self.get_prop("left")
        return float(value) if value is not None else None

    @left.setter
    def left(self, value: float | None) -> None:
        self.set_prop("left", None if value is None else float(value))

    @property
    def top(self) -> float | None:
        value = self.get_prop("top")
        return float(value) if value is not None else None

    @top.setter
    def top(self, value: float | None) -> None:
        self.set_prop("top", None if value is None else float(value))

    @property
    def right(self) -> float | None:
        value = self.get_prop("right")
        return float(value) if value is not None else None

    @right.setter
    def right(self, value: float | None) -> None:
        self.set_prop("right", None if value is None else float(value))

    @property
    def bottom(self) -> float | None:
        value = self.get_prop("bottom")
        return float(value) if value is not None else None

    @bottom.setter
    def bottom(self, value: float | None) -> None:
        self.set_prop("bottom", None if value is None else float(value))

    def frame(self, **kwargs: Any) -> "LayoutControl":
        self.patch(**kwargs)
        return self
