from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Popover"]

class Popover(Component):
    """Anchored pop-over panel displayed relative to a target widget.

    Renders a floating card positioned near an anchor widget within the Flutter
    widget tree, with configurable placement and transition options.

    Example:
        ```python
        pop = Popover(anchor=button, content=detail_card, position="bottom_start")
        ```

    Args:
        anchor: Widget that the popover is anchored to.
        content: Widget displayed inside the popover panel.
        open: Whether the popover is currently visible.
        position: Preferred placement relative to the anchor.
        offset: Pixel offset from the anchor in logical pixels.
        dismissible: Whether clicking outside the popover closes it.
        transition: Named transition to use when showing or hiding.
        transition_type: Category of transition animation to apply.
        duration_ms: Transition duration in milliseconds.
    """

    control_type = "popover"

    def __init__(
        self,
        anchor: Any | None = None,
        content: Any | None = None,
        *,
        open: bool | None = None,
        position: str | None = None,
        offset: Any | None = None,
        dismissible: bool | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            anchor=anchor,
            content=content,
            open=open,
            position=position,
            offset=offset,
            dismissible=dismissible,
            transition=transition,
            transition_type=transition_type,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
