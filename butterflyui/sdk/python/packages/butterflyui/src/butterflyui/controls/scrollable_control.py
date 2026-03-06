from __future__ import annotations

from .layout_control import LayoutControl

__all__ = ["ScrollableControl"]


class ScrollableControl(LayoutControl):
    """Shared scrollable behavior for controls with a viewport."""

    @property
    def scrollable(self) -> bool | None:
        value = self.get_prop("scrollable")
        return bool(value) if value is not None else None

    @scrollable.setter
    def scrollable(self, value: bool | None) -> None:
        self.set_prop("scrollable", None if value is None else bool(value))

    @property
    def initial_offset(self) -> float | None:
        value = self.get_prop("initial_offset")
        return float(value) if value is not None else None

    @initial_offset.setter
    def initial_offset(self, value: float | None) -> None:
        self.set_prop("initial_offset", None if value is None else float(value))
