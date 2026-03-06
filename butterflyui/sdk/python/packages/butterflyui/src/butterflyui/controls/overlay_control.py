from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["OverlayControl"]


class OverlayControl(LayoutControl):
    """Shared overlay behavior for dismissible or positioned popup controls."""

    @property
    def open(self) -> bool:
        return bool(self.get_prop("open", False))

    @open.setter
    def open(self, value: bool) -> None:
        self.set_prop("open", bool(value))

    @property
    def dismissible(self) -> bool | None:
        value = self.get_prop("dismissible")
        return bool(value) if value is not None else None

    @dismissible.setter
    def dismissible(self, value: bool | None) -> None:
        self.set_prop("dismissible", None if value is None else bool(value))

    @property
    def offset(self) -> Any:
        return self.get_prop("offset")

    @offset.setter
    def offset(self, value: Any) -> None:
        self.set_prop("offset", value)

    def show(self) -> "OverlayControl":
        self.open = True
        return self

    def hide(self) -> "OverlayControl":
        self.open = False
        return self
