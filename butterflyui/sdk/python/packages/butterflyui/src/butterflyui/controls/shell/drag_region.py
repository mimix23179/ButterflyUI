from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DragRegion"]

class DragRegion(Component):
    control_type = "drag_region"

    def __init__(
        self,
        child: Any | None = None,
        *,
        draggable: bool | None = None,
        maximize_on_double_tap: bool | None = None,
        emit_move: bool | None = None,
        native_drag: bool | None = None,
        native_maximize_action: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            draggable=draggable,
            maximize_on_double_tap=maximize_on_double_tap,
            emit_move=emit_move,
            native_drag=native_drag,
            native_maximize_action=native_maximize_action,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
