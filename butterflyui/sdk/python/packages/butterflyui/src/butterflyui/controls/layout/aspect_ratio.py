from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AspectRatio"]

class AspectRatio(Component):
    """
    Forces its child to a fixed width-to-height aspect ratio.

    The runtime wraps Flutter's ``AspectRatio`` widget. The child is scaled to
    satisfy ``ratio`` (width / height) while fitting the parent's constraints.
    Both ``ratio`` and ``aspect_ratio`` are accepted as aliases for the same
    property.

    ```python
    import butterflyui as bui

    bui.AspectRatio(
        bui.Image(src="photo.png"),
        ratio=16 / 9,
    )
    ```

    Args:
        ratio:
            The desired width-to-height ratio. Alias for ``aspect_ratio``.
        aspect_ratio:
            Alias for ``ratio``.
    """

    control_type = "aspect_ratio"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        ratio: float | None = None,
        aspect_ratio: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            ratio=ratio if ratio is not None else aspect_ratio,
            aspect_ratio=aspect_ratio if aspect_ratio is not None else ratio,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
