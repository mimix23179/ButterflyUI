from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Image"]

class Image(Component):
    """Network or asset image display.

    Renders a Flutter ``Image`` widget from the URL or asset path
    given in ``src``.  Additional sizing, fit, and alignment options
    can be passed through ``props`` or ``**kwargs``.

    Example::

        import butterflyui as bui

        img = bui.Image(src="https://example.com/photo.jpg")

    Args:
        src: 
            Image URL or local asset path.
    """
    control_type = "image"

    def __init__(
        self,
        src: str | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, src=src, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
