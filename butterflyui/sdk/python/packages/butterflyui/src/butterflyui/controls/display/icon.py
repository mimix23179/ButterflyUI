from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Icon"]

class Icon(Component):
    """Single Material icon glyph.

    Renders a Flutter ``Icon`` widget resolved from the ``icon`` name
    or code-point.  The icon can be sized and coloured, and an
    optional ``tooltip`` (passed via extra kwargs) wraps it in a
    ``Tooltip``.

    Example::

        import butterflyui as bui

        ic = bui.Icon(icon="favorite", size=24, color="#ef4444")

    Args:
        icon: 
            Material icon name string or integer code-point.
    """
    control_type = "icon"

    def __init__(
        self,
        icon: str | int | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, icon=icon, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
