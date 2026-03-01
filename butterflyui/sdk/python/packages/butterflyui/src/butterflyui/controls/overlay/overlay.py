from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Overlay"]

class Overlay(Component):
    """Generic full-screen overlay container for arbitrary content.

    Renders a layer that covers the Flutter widget tree with optional scrim
    and alignment control for positioned overlay content.

    Example:
        ```python
        overlay = Overlay(open=True, alignment="center", scrim_color="#80000000")
        ```

    Args:
        open: Whether the overlay is currently visible.
        dismissible: Whether tapping the scrim closes the overlay.
        alignment: Alignment of content within the overlay surface.
        scrim_color: Color of the translucent background scrim.
        events: Flutter client events to subscribe to.
    """

    control_type = "overlay"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        dismissible: bool | None = None,
        alignment: Any | None = None,
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
            dismissible=dismissible,
            alignment=alignment,
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
