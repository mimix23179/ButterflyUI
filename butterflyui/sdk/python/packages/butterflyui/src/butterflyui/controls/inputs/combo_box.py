from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ComboBox"]


class ComboBox(Component):
    """Editable combo-box with optional async loading state."""

    control_type = "combo_box"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        groups: list[Mapping[str, Any]] | None = None,
        label: str | None = None,
        hint: str | None = None,
        placeholder: str | None = None,
        loading: bool | None = None,
        async_source: str | None = None,
        debounce_ms: int | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                value=value,
                options=options if options is not None else items,
                items=items if items is not None else options,
                groups=groups,
                label=label,
                hint=hint if hint is not None else placeholder,
                placeholder=placeholder if placeholder is not None else hint,
                loading=loading,
                async_source=async_source,
                debounce_ms=debounce_ms,
                enabled=enabled,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": list(options)})

    def set_loading(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_loading", {"value": value})
