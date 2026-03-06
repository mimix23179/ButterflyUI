from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ..core.control import Control as CoreControl, prepare_control_class

__all__ = ["BaseControl", "butterfly_control"]


class BaseControl(CoreControl):
    """Reorganized shared base class for renderable ButterflyUI controls."""

    def init(self) -> None:
        """Lifecycle hook for declarative controls generated via `@butterfly_control`."""
        return None

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


def butterfly_control(
    control_type: str | None = None,
    *,
    field_aliases: Mapping[str, str] | None = None,
    doc_only_fields: Iterable[str] | None = None,
    positional_fields: Iterable[str] | None = None,
):
    def wrapper(cls: type[BaseControl]) -> type[BaseControl]:
        if control_type:
            cls.control_type = str(control_type)
        if field_aliases:
            aliases = dict(getattr(cls, "_butterflyui_field_aliases", {}))
            aliases.update(
                {
                    str(key): str(value)
                    for key, value in field_aliases.items()
                    if str(key) and str(value)
                }
            )
            cls._butterflyui_field_aliases = aliases
        if doc_only_fields:
            declared = list(getattr(cls, "_butterflyui_doc_only_fields", ()))
            for name in doc_only_fields:
                value = str(name)
                if value and value not in declared:
                    declared.append(value)
            cls._butterflyui_doc_only_fields = tuple(declared)
        if positional_fields:
            declared = list(getattr(cls, "_butterflyui_positional_fields", ()))
            for name in positional_fields:
                value = str(name)
                if value and value not in declared:
                    declared.append(value)
            cls._butterflyui_positional_fields = tuple(declared)
        prepare_control_class(cls)
        return cls

    return wrapper
