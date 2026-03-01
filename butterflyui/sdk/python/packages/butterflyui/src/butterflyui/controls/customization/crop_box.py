from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CropBox"]

class CropBox(Component):
    """
    Overlay that renders a rectangular crop region on top of a child control.

    The runtime draws the crop rectangle with a coloured border and a
    semi-transparent shade over the area outside the crop. The rect is
    expressed as ``{"x", "y", "width", "height"}`` in logical pixels.
    Changes to the crop region emit ``"change"`` and ``"select"`` events.

    ```python
    import butterflyui as bui

    bui.CropBox(
        my_image,
        rect={"x": 24, "y": 24, "width": 120, "height": 90},
        border_color="#448aff",
    )
    ```

    Args:
        rect: 
            Crop rectangle as ``{"x": ..., "y": ..., "width": ..., "height": ...}``. Defaults to ``{"x": 24, "y": 24, "width": 120, "height": 90}``.
        shade_color: 
            Colour of the semi-transparent shade painted over the non-cropped area. Defaults to ``black26`` at ``0.18`` opacity.
        border_color: 
            Colour of the crop rectangle border. Defaults to ``Colors.blueAccent``.
        border_width: 
            Stroke width of the crop rectangle border. Defaults to ``2``.
        enabled: 
            If ``False``, the crop overlay is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "crop_box"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        rect: Mapping[str, Any] | None = None,
        shade_color: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            rect=dict(rect) if rect is not None else None,
            shade_color=shade_color,
            border_color=border_color,
            border_width=border_width,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_rect(self, session: Any, rect: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_rect", {"rect": dict(rect)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
