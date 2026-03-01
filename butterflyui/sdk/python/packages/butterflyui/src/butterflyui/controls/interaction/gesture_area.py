from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GestureArea"]

class GestureArea(Component):
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

    ```python
    import butterflyui as bui

    bui.GestureArea(
        bui.Container(width=200, height=200),
        tap_enabled=True,
        pan_enabled=True,
    )
    ```

    Args:
        enabled:
            Master switch.  If ``False``, no gesture events are fired.
        tap_enabled:
            If ``True``, single-tap events are captured and emitted.
        double_tap_enabled:
            If ``True``, double-tap events are captured and emitted.
        long_press_enabled:
            If ``True``, long-press events are captured and emitted.
        pan_enabled:
            If ``True``, pan/drag gesture events are captured and
            emitted.
        scale_enabled:
            If ``True``, pinch-to-scale and rotate gesture events are
            captured and emitted.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "gesture_area"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        tap_enabled: bool | None = None,
        double_tap_enabled: bool | None = None,
        long_press_enabled: bool | None = None,
        pan_enabled: bool | None = None,
        scale_enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            tap_enabled=tap_enabled,
            double_tap_enabled=double_tap_enabled,
            long_press_enabled=long_press_enabled,
            pan_enabled=pan_enabled,
            scale_enabled=scale_enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
