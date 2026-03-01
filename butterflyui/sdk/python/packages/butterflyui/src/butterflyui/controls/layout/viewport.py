from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Viewport"]

class Viewport(Component):
    """
    Clipped viewport that reveals a fixed-size window into its child.

    The runtime creates a fixed ``width`` x ``height`` window positioned at
    ``x``/``y`` offset. Only the portion of the child within the window is
    visible. ``clip`` enables clipping of content outside the window. Use
    ``set_offset`` to programmatically pan the viewport from Python.

    ```python
    import butterflyui as bui

    viewport = bui.Viewport(
        bui.Image(src="large_map.png"),
        width=640,
        height=480,
        x=100,
        y=200,
        clip=True,
        events=["pan"],
    )
    ```

    Args:
        width:
            Width of the viewport window in logical pixels.
        height:
            Height of the viewport window in logical pixels.
        x:
            Horizontal offset into the child's coordinate space.
        y:
            Vertical offset into the child's coordinate space.
        clip:
            When ``True`` clips the child content outside the viewport bounds.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "viewport"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        width: float | None = None,
        height: float | None = None,
        x: float | None = None,
        y: float | None = None,
        clip: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            x=x,
            y=y,
            clip=clip,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_offset(self, session: Any, *, x: float, y: float) -> dict[str, Any]:
        return self.invoke(session, "set_offset", {"x": float(x), "y": float(y)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
