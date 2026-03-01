from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DragRegion"]

class DragRegion(Component):
    """
    Transparent hit-test region that enables native window dragging on desktop.

    The runtime registers its area as a window-drag surface. ``draggable``
    enables the drag gesture. ``maximize_on_double_tap`` maximises the window
    on double-tap/double-click. ``emit_move`` fires move events to Python
    as the window is dragged. ``native_drag`` delegates to the OS drag
    implementation. ``native_maximize_action`` uses the OS double-click
    maximize behaviour.

    ```python
    import butterflyui as bui

    bui.DragRegion(
        bui.Text("Drag here"),
        draggable=True,
        maximize_on_double_tap=True,
        events=["move"],
    )
    ```

    Args:
        draggable:
            When ``True`` the region participates in window dragging.
        maximize_on_double_tap:
            When ``True`` double-tapping the region maximises the window.
        emit_move:
            When ``True`` window-move events are emitted to Python.
        native_drag:
            When ``True`` the OS native drag handler is used.
        native_maximize_action:
            When ``True`` the OS native maximize-on-double-click behaviour
            is used.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

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
