from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Chip"]


class Chip(Component):
    """Unified chip surface for individual chips and grouped chips.

    This control replaces the old ``chip_group`` API. Use ``options``/``items``
    to render grouped chips and ``multi_select`` + ``values`` for multi mode.
    """

    control_type = "chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                label=label,
                value=value,
                options=options if options is not None else items,
                items=items if items is not None else options,
                values=values,
                multi_select=multi_select,
                selected=selected,
                enabled=enabled,
                dismissible=dismissible,
                color=color,
                dense=dense,
                spacing=spacing,
                run_spacing=run_spacing,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": list(values)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
