from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SafeArea"]

class SafeArea(Component):
    """
    Insets its child to avoid OS intrusions such as notches and status bars.

    The runtime wraps Flutter's ``SafeArea``. Use the boolean edge flags to
    enable or disable safe-area insets per side. ``minimum`` overrides the
    OS-reported inset with a minimum padding value. Set
    ``maintain_bottom_view_padding`` to preserve bottom padding when the
    on-screen keyboard is displayed.

    ```python
    import butterflyui as bui

    bui.SafeArea(
        bui.Text("Safe content"),
        top=True,
        bottom=True,
    )
    ```

    Args:
        left:
            When ``True`` applies the safe-area inset on the left edge.
        top:
            When ``True`` applies the safe-area inset on the top edge.
        right:
            When ``True`` applies the safe-area inset on the right edge.
        bottom:
            When ``True`` applies the safe-area inset on the bottom edge.
        minimum:
            Minimum inset padding that overrides the OS-reported value.
        maintain_bottom_view_padding:
            When ``True`` preserves the bottom view padding when the keyboard
            is visible.
    """

    control_type = "safe_area"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        left: bool | None = None,
        top: bool | None = None,
        right: bool | None = None,
        bottom: bool | None = None,
        minimum: Any | None = None,
        maintain_bottom_view_padding: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
            minimum=minimum,
            maintain_bottom_view_padding=maintain_bottom_view_padding,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
