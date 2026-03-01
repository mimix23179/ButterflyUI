from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PanZoom"]

class PanZoom(Component):
    """Interactive pan-and-zoom wrapper backed by Flutter's
    ``InteractiveViewer``.

    The runtime enables two-finger pinch-to-zoom and drag-to-pan over
    the child content.  Scale constraints, initial viewport position,
    boundary margins, and individual gesture toggles are all
    configurable.

    Example::

        import butterflyui as bui

        viewer = bui.PanZoom(
            bui.Image(src="map.png"),
            min_scale=0.5,
            max_scale=4.0,
            clip=True,
        )

    Args:
        enabled: 
            Master toggle.  When ``False`` pan and zoom gestures
            are disabled.
        scale: 
            Initial or current zoom scale factor.
        x: 
            Horizontal viewport offset.
        y: 
            Vertical viewport offset.
        min_scale: 
            Minimum allowed zoom scale.  Defaults to ``0.8``.
        max_scale: 
            Maximum allowed zoom scale.  Defaults to ``2.5``.
        boundary_margin: 
            Margin (in logical pixels or an ``EdgeInsets``-like value) 
            around the child within which panning is permitted.
        pan_enabled: 
            When ``False`` drag-to-pan is disabled while
            zoom remains active.
        zoom_enabled: 
            When ``False`` pinch-to-zoom is disabled while
            pan remains active.
        clip: 
            When ``True`` content outside the viewport bounds is
            clipped.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "pan_zoom"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        scale: float | None = None,
        x: float | None = None,
        y: float | None = None,
        min_scale: float | None = None,
        max_scale: float | None = None,
        boundary_margin: Any | None = None,
        pan_enabled: bool | None = None,
        zoom_enabled: bool | None = None,
        clip: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            scale=scale,
            x=x,
            y=y,
            min_scale=min_scale,
            max_scale=max_scale,
            boundary_margin=boundary_margin,
            pan_enabled=pan_enabled,
            zoom_enabled=zoom_enabled,
            clip=clip,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_transform(self, session: Any, *, scale: float | None = None, x: float | None = None, y: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if scale is not None:
            payload["scale"] = scale
        if x is not None:
            payload["x"] = x
        if y is not None:
            payload["y"] = y
        return self.invoke(session, "set_transform", payload)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
