from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["InputControl"]


class InputControl(LayoutControl):
    """Shared input behavior for controls that carry a user-editable value."""

    @property
    def value(self) -> Any:
        return self.get_prop("value")

    @value.setter
    def value(self, value: Any) -> None:
        self.set_prop("value", value)

    @property
    def label(self) -> str | None:
        value = self.get_prop("label")
        return str(value) if value is not None else None

    @label.setter
    def label(self, value: str | None) -> None:
        self.set_prop("label", value)

    @property
    def placeholder(self) -> str | None:
        value = self.get_prop("placeholder")
        return str(value) if value is not None else None

    @placeholder.setter
    def placeholder(self, value: str | None) -> None:
        self.set_prop("placeholder", value)
