from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Tooltip"]

class Tooltip(Component):
    """Tooltip that reveals a short descriptive message on hover.

    Wraps a child widget within the Flutter widget tree and shows a floating
    label after a configurable delay.

    Example:
        ```python
        tip = Tooltip(icon_widget, message="Delete item", wait_ms=500)
        ```

    Args:
        child: Widget that triggers the tooltip on hover.
        message: Text displayed in the tooltip balloon.
        prefer_below: Whether to prefer placing the tooltip below the child.
        wait_ms: Hover duration in milliseconds before the tooltip appears.
    """

    control_type = "tooltip"

    def __init__(
        self,
        child: Any | None = None,
        *,
        message: str | None = None,
        prefer_below: bool | None = None,
        wait_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            message=message,
            prefer_below=prefer_below,
            wait_ms=wait_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
