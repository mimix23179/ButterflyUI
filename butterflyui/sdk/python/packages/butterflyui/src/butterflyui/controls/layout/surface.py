from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Surface"]

class Surface(Component):
    """
    Elevated surface card with background color, border, and corner radius.

    A simplified decorated container for material-style surfaces. Accepts
    ``padding`` for inner spacing, ``radius`` for corner rounding, ``bgcolor``
    for the background fill, and ``border_color``/``border_width`` for an
    optional border stroke.

    ```python
    import butterflyui as bui

    bui.Surface(
        bui.Text("Card content"),
        radius=12,
        bgcolor="#FFFFFF",
        padding=16,
    )
    ```

    Args:
        padding:
            Inner spacing between the surface edge and its children.
        radius:
            Corner radius in logical pixels.
        bgcolor:
            Background fill color.
        border_color:
            Border stroke color.
        border_width:
            Border stroke width in logical pixels.
    """

    control_type = "surface"

    def __init__(
        self,
        *children: Any,
        padding: Any | None = None,
        radius: float | None = None,
        bgcolor: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            padding=padding,
            radius=radius,
            bgcolor=bgcolor,
            border_color=border_color,
            border_width=border_width,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
