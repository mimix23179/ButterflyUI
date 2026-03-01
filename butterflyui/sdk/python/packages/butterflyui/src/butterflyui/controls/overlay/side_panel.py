from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .slide_panel import SlidePanel

__all__ = ["SidePanel"]

class SidePanel(SlidePanel):
    """Persistent side panel that slides in from a screen edge.

    Extends SlidePanel to provide a named side-panel variant within the Flutter
    widget tree using the same edge-anchored slide behaviour.

    Example:
        ```python
        panel = SidePanel(open=True, side="left", size=320)
        ```

    Args:
        open: Whether the panel is currently visible.
        side: Edge from which the panel slides in (left, right, top, bottom).
        size: Width or height of the panel in logical pixels.
        dismissible: Whether tapping the scrim closes the panel.
        scrim_color: Color of the background scrim overlay.
        events: Flutter client events to subscribe to.
    """

    control_type = "side_panel"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        scrim_color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            *children,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            scrim_color=scrim_color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
