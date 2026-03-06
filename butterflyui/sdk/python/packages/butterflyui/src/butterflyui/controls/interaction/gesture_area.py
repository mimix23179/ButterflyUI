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

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
