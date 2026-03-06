from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["Toast"]

@butterfly_control('toast', positional_fields=('message',))
class Toast(OverlayControl):
    """
    Ephemeral notification toast that appears briefly and auto-dismisses.

    The runtime renders a transient message overlay. ``message`` sets the
    notification text. ``open`` controls visibility. ``duration_ms`` sets
    the auto-dismiss delay. ``action_label`` adds an inline action button.
    ``variant`` applies a semantic color scheme.

    Example:

    ```python
    import butterflyui as bui

    bui.Toast(
        message="Changes saved!",
        open=True,
        duration_ms=3000,
        variant="success",
    )
    ```
    """

    message: str | None = None
    """
    Main message text rendered inside the control.
    """

    duration_ms: int | None = None
    """
    Milliseconds before the toast auto-dismisses. Use ``0`` to
    disable auto-dismiss.
    """

    action_label: str | None = None
    """
    Label for an optional inline action button.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    instant: Any | None = None
    """
    Instant value forwarded to the `toast` runtime control.
    """

    label: Any | None = None
    """
    Primary label rendered by the control.
    """

    priority: Any | None = None
    """
    Priority value forwarded to the `toast` runtime control.
    """

    use_flushbar: Any | None = None
    """
    Use flushbar value forwarded to the `toast` runtime control.
    """

    use_fluttertoast: Any | None = None
    """
    Use fluttertoast value forwarded to the `toast` runtime control.
    """

    toast_position: Any | None = None
    """
    Toast position value forwarded to the `toast` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `toast` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `toast` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `toast` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `toast` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `toast` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `toast` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `toast` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `toast` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `toast` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `toast` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `toast` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `toast` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `toast` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `toast` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `toast` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `toast` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `toast` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `toast` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `toast` runtime control.
    """

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def show(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": True})

    def hide(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": False})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
