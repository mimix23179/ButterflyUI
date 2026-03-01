from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SplitView"]

class SplitView(Component):
    """
    Two-panel layout split along a horizontal or vertical axis.

    The runtime renders two children separated by a divider. ``axis`` sets
    the split direction; ``ratio`` sets the initial fractional split position
    (0.0-1.0). ``draggable`` enables the user to drag the divider.
    ``divider_size`` controls the visible width or height of the divider.
    For bounded drag behavior prefer ``SplitPane``.

    ```python
    import butterflyui as bui

    bui.SplitView(
        bui.Text("Left"),
        bui.Text("Right"),
        axis="horizontal",
        ratio=0.5,
        draggable=True,
    )
    ```

    Args:
        axis:
            Split direction. Values: ``"horizontal"``, ``"vertical"``.
        ratio:
            Initial fractional position of the divider (0.0-1.0).
        min_ratio:
            Minimum allowed divider ratio during drag.
        max_ratio:
            Maximum allowed divider ratio during drag.
        draggable:
            When ``True`` the user can drag the divider to resize panels.
        divider_size:
            Width or height of the divider affordance in logical pixels.
    """

    control_type = "split_view"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        ratio: float | None = None,
        min_ratio: float | None = None,
        max_ratio: float | None = None,
        draggable: bool | None = None,
        divider_size: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            axis=axis,
            ratio=ratio,
            min_ratio=min_ratio,
            max_ratio=max_ratio,
            draggable=draggable,
            divider_size=divider_size,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
