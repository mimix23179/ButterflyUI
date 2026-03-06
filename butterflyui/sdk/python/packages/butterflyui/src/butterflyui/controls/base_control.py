from __future__ import annotations

from collections.abc import Iterable
from typing import Any

from ..core.control import Control as CoreControl

__all__ = ["BaseControl"]


class BaseControl(CoreControl):
    """Reorganized shared base class for renderable ButterflyUI controls."""

    def get_prop(self, name: str, default: Any = None) -> Any:
        return self._get(name, default)

    def set_prop(self, name: str, value: Any) -> None:
        self._set(name, value)

    def append_child(self, child: Any) -> "BaseControl":
        self.children.append(child)
        return self

    def extend_children(self, children: Iterable[Any]) -> "BaseControl":
        self.children.extend(children)
        return self

    def set_children(self, children: Iterable[Any]) -> "BaseControl":
        self.children.clear()
        self.children.extend(children)
        return self
