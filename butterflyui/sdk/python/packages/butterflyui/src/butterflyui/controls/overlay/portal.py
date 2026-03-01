from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Portal"]

class Portal(Component):
    """Portal that teleports content to a different point in the widget tree.

    Renders a primary child widget at the call site while projecting portal
    content to an overlay layer within the Flutter widget tree.

    Example:
        ```python
        p = Portal(anchor_widget, tooltip_widget, open=True, alignment="top_center")
        ```

    Args:
        child: Widget rendered inline at the portal origin.
        portal: Widget projected into the overlay layer.
        open: Whether the portal content is currently visible.
        dismissible: Whether tapping outside dismisses the portal content.
        passthrough: Whether pointer events pass through portal content.
        alignment: Alignment of the portal content in the overlay.
        offset: Pixel offset of portal content from its aligned position.
    """

    control_type = "portal"

    def __init__(
        self,
        child: Any | None = None,
        portal: Any | None = None,
        *,
        open: bool | None = None,
        dismissible: bool | None = None,
        passthrough: bool | None = None,
        alignment: Any | None = None,
        offset: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            child=child,
            portal=portal,
            open=open,
            dismissible=dismissible,
            passthrough=passthrough,
            alignment=alignment,
            offset=offset,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
