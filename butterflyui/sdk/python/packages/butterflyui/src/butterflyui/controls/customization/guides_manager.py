from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GuidesManager"]

class GuidesManager(Component):
    """
    Non-interactive overlay that paints alignment guide lines.

    The runtime renders vertical (``guides_x``) and horizontal
    (``guides_y``) lines using a ``CustomPaint`` painter wrapped in an
    ``IgnorePointer``, so the guides never intercept touch events.

    ```python
    import butterflyui as bui

    bui.GuidesManager(
        guides_x=[100.0, 200.0],
        guides_y=[50.0, 150.0],
        visible=True,
    )
    ```

    Args:
        guides_x: 
            List of vertical guide-line positions in logical pixels.
        guides_y: 
            List of horizontal guide-line positions in logical pixels.
        snap_tolerance: 
            Distance in pixels within which objects snap to a guide.
        visible: 
            If ``True`` (default), the guide lines are drawn.
        locked: 
            If ``True``, guides cannot be moved interactively.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "guides_manager"

    def __init__(
        self,
        *,
        guides_x: list[float] | None = None,
        guides_y: list[float] | None = None,
        snap_tolerance: float | None = None,
        visible: bool | None = None,
        locked: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            guides_x=guides_x,
            guides_y=guides_y,
            snap_tolerance=snap_tolerance,
            visible=visible,
            locked=locked,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_guides(self, session: Any, guides_x: list[float], guides_y: list[float]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_guides",
            {"guides_x": [float(v) for v in guides_x], "guides_y": [float(v) for v in guides_y]},
        )

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
