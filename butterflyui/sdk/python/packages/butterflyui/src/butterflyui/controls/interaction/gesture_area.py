from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["GestureArea"]

@butterfly_control('gesture_area')
class GestureArea(LayoutControl):
    """
    Transparent overlay that captures gesture events over its child.

    Wraps the child in a ``GestureDetector``.  Each gesture type can
    be enabled or disabled individually; only enabled gesture types
    emit events.  Emitted events carry pointer position and metadata:

    - ``tap`` — single tap with ``{"x", "y"}`` position.
    - ``double_tap`` — double tap with position.
    - ``long_press`` — long press with position.
    - ``pan_start`` / ``pan_update`` / ``pan_end`` — pan gesture
      with delta and velocity.
    - ``scale_start`` / ``scale_update`` / ``scale_end`` — pinch/scale
      gesture with scale and rotation.

    Example:

    ```python
    import butterflyui as bui

    bui.GestureArea(
        bui.Container(width=200, height=200),
        tap_enabled=True,
        pan_enabled=True,
    )
    ```
    """

    tap_enabled: bool | None = None
    """
    If ``True``, single-tap events are captured and emitted.
    """

    double_tap_enabled: bool | None = None
    """
    If ``True``, double-tap events are captured and emitted.
    """

    long_press_enabled: bool | None = None
    """
    If ``True``, long-press events are captured and emitted.
    """

    pan_enabled: bool | None = None
    """
    If ``True``, pan/drag gesture events are captured and
    emitted.
    """

    scale_enabled: bool | None = None
    """
    If ``True``, pinch-to-scale and rotate gesture events are
    captured and emitted.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `gesture_area` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `gesture_area` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `gesture_area` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `gesture_area` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `gesture_area` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `gesture_area` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `gesture_area` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `gesture_area` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `gesture_area` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `gesture_area` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `gesture_area` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `gesture_area` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `gesture_area` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `gesture_area` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `gesture_area` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `gesture_area` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `gesture_area` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `gesture_area` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `gesture_area` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
