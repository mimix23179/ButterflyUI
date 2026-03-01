from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Box"]

class Box(Component):
    """
    Simple sized box that constrains and optionally decorates its children.

    The runtime renders a lightweight container. Accepts optional ``width``,
    ``height``, ``padding``, ``margin``, ``alignment``, and ``bgcolor``
    styling values.

    ```python
    import butterflyui as bui

    bui.Box(
        bui.Text("Inside a box"),
        width=200,
        height=100,
        bgcolor="#F0F0F0",
        padding=8,
    )
    ```

    Args:
        width:
            Fixed width in logical pixels. Accepts a number or a sizing token.
        height:
            Fixed height in logical pixels. Accepts a number or a sizing token.
        padding:
            Inner spacing between the box edge and its children.
        margin:
            Outer spacing around the box.
        alignment:
            How children are aligned within the box.
        bgcolor:
            Background fill color.
    """

    control_type = "box"

    def __init__(
        self,
        *children: Any,
        width: Any | None = None,
        height: Any | None = None,
        padding: Any | None = None,
        margin: Any | None = None,
        alignment: Any | None = None,
        bgcolor: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            alignment=alignment,
            bgcolor=bgcolor,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
