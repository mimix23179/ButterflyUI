from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["WindowDragRegion"]

@butterfly_control('window_drag_region')
class WindowDragRegion(LayoutControl):
    """
    Native window-drag hit area typically placed in a custom title bar.

    The runtime registers the region as a native window-drag surface on
    supported desktop platforms. ``draggable`` enables the interaction.
    ``maximize_on_double_tap`` triggers window maximization on double-click.
    ``emit_move`` fires window-position events to Python as the window moves.
    ``native_drag`` delegates to the platform's native drag API.
    ``native_maximize_action`` uses the OS-level maximize-on-double-click
    behaviour.

    Example:

    ```python
    import butterflyui as bui

    bui.WindowDragRegion(
        bui.Text("My App"),
        draggable=True,
        maximize_on_double_tap=True,
    )
    ```
    """

    draggable: bool | None = None
    """
    When ``True`` the region participates in native window dragging.
    """

    maximize_on_double_tap: bool | None = None
    """
    When ``True`` double-clicking the region maximises the window.
    """

    emit_move: bool | None = None
    """
    When ``True`` window-position events are emitted to Python.
    """

    native_drag: bool | None = None
    """
    When ``True`` the platform's native drag API is used.
    """

    native_maximize_action: bool | None = None
    """
    When ``True`` the OS-level maximize-on-double-click behaviour
    is used.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
