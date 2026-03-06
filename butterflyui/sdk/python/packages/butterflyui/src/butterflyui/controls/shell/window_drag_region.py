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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `window_drag_region` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `window_drag_region` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `window_drag_region` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `window_drag_region` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `window_drag_region` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `window_drag_region` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `window_drag_region` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `window_drag_region` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `window_drag_region` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `window_drag_region` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `window_drag_region` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `window_drag_region` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `window_drag_region` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `window_drag_region` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `window_drag_region` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `window_drag_region` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `window_drag_region` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `window_drag_region` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `window_drag_region` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
