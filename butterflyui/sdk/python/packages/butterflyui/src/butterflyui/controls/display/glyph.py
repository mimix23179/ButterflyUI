from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .icon import Icon

__all__ = ["Glyph"]

class Glyph(Icon):
    """Named glyph icon with optional tooltip.

    Extends ``Icon`` to accept a ``glyph`` string or code-point that
    is resolved via the ``buildIconValue`` helper at runtime.  Falls
    back to rendering the raw text at the given ``size`` when the
    glyph cannot be mapped to a Material icon.  An optional
    ``tooltip`` wraps the widget in a ``Tooltip``.

    Example::

        import butterflyui as bui

        g = bui.Glyph(glyph="star", size=20, color="#facc15")

    Args:
        glyph: 
            Icon name, code-point, or emoji string.  Passed to the ``Icon`` base as the icon value.
        icon: 
            Alias for ``glyph``.
        tooltip: 
            Hover tooltip text.  When non-empty the glyph is wrapped in a ``Tooltip`` widget.
        size: 
            Icon size in logical pixels.
        color: 
            Icon foreground colour.
    """
    control_type = "glyph"

    def __init__(
        self,
        glyph: str | int | None = None,
        *,
        icon: str | int | None = None,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            icon=icon if icon is not None else glyph,
            props=merge_props(props, tooltip=tooltip, size=size, color=color),
            style=style,
            strict=strict,
            **kwargs,
        )
