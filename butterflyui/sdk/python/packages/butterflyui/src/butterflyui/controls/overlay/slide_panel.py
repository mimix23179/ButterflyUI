from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SlidePanel"]

class SlidePanel(Component):
    """Slide-in panel anchored to a screen edge.

    Renders a panel that animates into view from a specified edge of the Flutter
    widget tree, with optional scrim and dismiss support.

    Example:
        ```python
        panel = SlidePanel(open=True, side="right", size=360)
        ```

    Args:
        open: Whether the panel is currently visible.
        side: Edge from which the panel slides in (left, right, top, bottom).
        size: Width or height of the panel in logical pixels.
        dismissible: Whether tapping the scrim closes the panel.
        scrim_color: Color of the background scrim overlay.
        events: Flutter client events to subscribe to.
    """

    control_type = "slide_panel"

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
        merged = merge_props(
            props,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            scrim_color=scrim_color,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
