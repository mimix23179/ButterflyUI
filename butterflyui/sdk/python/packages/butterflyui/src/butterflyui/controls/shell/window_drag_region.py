from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["WindowDragRegion"]

class WindowDragRegion(Component):
    """
    Native window-drag hit area typically placed in a custom title bar.

    The runtime registers the region as a native window-drag surface on
    supported desktop platforms. ``draggable`` enables the interaction.
    ``maximize_on_double_tap`` triggers window maximization on double-click.
    ``emit_move`` fires window-position events to Python as the window moves.
    ``native_drag`` delegates to the platform's native drag API.
    ``native_maximize_action`` uses the OS-level maximize-on-double-click
    behaviour.

    ```python
    import butterflyui as bui

    bui.WindowDragRegion(
        bui.Text("My App"),
        draggable=True,
        maximize_on_double_tap=True,
    )
    ```

    Args:
        draggable:
            When ``True`` the region participates in native window dragging.
        maximize_on_double_tap:
            When ``True`` double-clicking the region maximises the window.
        emit_move:
            When ``True`` window-position events are emitted to Python.
        native_drag:
            When ``True`` the platform's native drag API is used.
        native_maximize_action:
            When ``True`` the OS-level maximize-on-double-click behaviour
            is used.
    """

    control_type = "window_drag_region"

    def __init__(
        self,
        child: Any | None = None,
        *,
        draggable: bool | None = None,
        maximize_on_double_tap: bool | None = None,
        emit_move: bool | None = None,
        native_drag: bool | None = None,
        native_maximize_action: bool | None = None,
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
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
