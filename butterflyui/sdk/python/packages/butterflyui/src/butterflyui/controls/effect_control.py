from __future__ import annotations

from typing import Any

from .scope_control import ScopeControl

__all__ = ["EffectControl"]


class EffectControl(ScopeControl):
    """Shared child-wrapping behavior for effect and decorator controls."""

    @property
    def child(self) -> Any:
        if self.children:
            return self.children[0]
        return self.get_prop("child")

    @child.setter
    def child(self, value: Any) -> None:
        if self.children:
            self.children[0] = value
        elif value is None:
            self.set_prop("child", None)
        else:
            self.children.append(value)

    @property
    def enabled(self) -> bool | None:
        value = self.get_prop("enabled")
        return bool(value) if value is not None else None

    @enabled.setter
    def enabled(self, value: bool | None) -> None:
        self.set_prop("enabled", None if value is None else bool(value))
