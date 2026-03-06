from __future__ import annotations

from typing import Any

from .base_control import BaseControl

__all__ = ["Control", "Component"]


class Control(BaseControl):
    """Common props shared by most renderable ButterflyUI controls."""

    @property
    def key(self) -> str | None:
        value = self.get_prop("key")
        return str(value) if value is not None else None

    @key.setter
    def key(self, value: str | None) -> None:
        self.set_prop("key", value)

    @property
    def visible(self) -> bool:
        return bool(self.get_prop("visible", True))

    @visible.setter
    def visible(self, value: bool) -> None:
        self.set_prop("visible", bool(value))

    @property
    def enabled(self) -> bool | None:
        value = self.get_prop("enabled")
        return bool(value) if value is not None else None

    @enabled.setter
    def enabled(self, value: bool | None) -> None:
        self.set_prop("enabled", None if value is None else bool(value))

    @property
    def tooltip(self) -> str | None:
        value = self.get_prop("tooltip")
        return str(value) if value is not None else None

    @tooltip.setter
    def tooltip(self, value: str | None) -> None:
        self.set_prop("tooltip", value)

    @property
    def semantics(self) -> Any:
        return self.get_prop("semantics")

    @semantics.setter
    def semantics(self, value: Any) -> None:
        self.set_prop("semantics", value)


Component = Control
