from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["ScopeControl"]


class ScopeControl(LayoutControl):
    """Shared subtree scope behavior for style and umbrella controls."""

    @property
    def classes(self) -> Any:
        return self.get_prop("classes")

    @classes.setter
    def classes(self, value: Any) -> None:
        self.set_prop("classes", value)

    @property
    def state(self) -> str | None:
        value = self.get_prop("state")
        return str(value) if value is not None else None

    @state.setter
    def state(self, value: str | None) -> None:
        self.set_prop("state", value)

    @property
    def variant(self) -> Any:
        return self.get_prop("variant")

    @variant.setter
    def variant(self, value: Any) -> None:
        self.set_prop("variant", value)
