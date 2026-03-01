from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Stack"]

class Stack(Component):
    """
    Overlapping-children container that layers widgets on top of each other.

    The runtime wraps Flutter's ``Stack`` widget. ``alignment`` positions
    un-positioned children within the stack bounds. ``fit`` controls how the
    stack sizes itself: ``"loose"`` (shrink to the largest child) or
    ``"expand"`` (fills the parent). ``clip`` enables clipping of children
    that overflow the stack bounds.

    ```python
    import butterflyui as bui

    bui.Stack(
        bui.Image(src="background.png"),
        bui.Text("Overlay text"),
        alignment="center",
    )
    ```

    Args:
        alignment:
            Aligns un-positioned children within the stack. Accepts a string
            alignment name or an ``{x, y}`` mapping.
        fit:
            How the stack sizes itself. Values: ``"loose"``, ``"expand"``.
        clip:
            When ``True`` children that overflow the stack bounds are clipped.
    """

    control_type = "stack"

    def __init__(
        self,
        *children: Any,
        alignment: Any | None = None,
        fit: str | None = None,
        clip: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            alignment=alignment,
            fit=fit,
            clip=clip,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
