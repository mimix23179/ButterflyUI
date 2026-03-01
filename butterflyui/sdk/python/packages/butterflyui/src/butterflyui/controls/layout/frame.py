from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Frame"]

class Frame(Component):
    """
    Sized and decorated frame with constraints, spacing, and visual styling.

    The runtime renders a container that applies combined width/height
    constraints (including min/max bounds), padding/margin spacing, background
    color, border, corner radius, and clip behaviour. ``alignment`` positions
    the child within the frame.

    ```python
    import butterflyui as bui

    bui.Frame(
        bui.Text("Content"),
        width=400,
        min_height=100,
        padding=16,
        bgcolor="#FAFAFA",
        radius=8,
        events=["resize"],
    )
    ```

    Args:
        width:
            Fixed width in logical pixels.
        height:
            Fixed height in logical pixels.
        min_width:
            Minimum width constraint in logical pixels.
        min_height:
            Minimum height constraint in logical pixels.
        max_width:
            Maximum width constraint in logical pixels.
        max_height:
            Maximum height constraint in logical pixels.
        padding:
            Inner spacing between the frame edge and its child.
        margin:
            Outer spacing around the frame.
        alignment:
            How the child is aligned inside the frame.
        bgcolor:
            Background fill color.
        border_color:
            Border stroke color.
        border_width:
            Border stroke width in logical pixels.
        radius:
            Corner radius in logical pixels.
        clip_behavior:
            Anti-aliasing clip mode. Values: ``"hardEdge"``, ``"antiAlias"``,
            ``"antiAliasWithSaveLayer"``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "frame"

    def __init__(
        self,
        *children: Any,
        width: float | None = None,
        height: float | None = None,
        min_width: float | None = None,
        min_height: float | None = None,
        max_width: float | None = None,
        max_height: float | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        clip_behavior: str | None = None,
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
            min_width=min_width,
            min_height=min_height,
            max_width=max_width,
            max_height=max_height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            clip_behavior=clip_behavior,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
