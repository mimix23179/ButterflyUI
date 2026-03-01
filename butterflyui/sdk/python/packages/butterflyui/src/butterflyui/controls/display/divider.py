from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Divider"]

class Divider(Component):
    """Thin horizontal or vertical line separator.

    Renders a Material ``Divider`` (horizontal by default) or
    ``VerticalDivider`` when ``vertical`` is ``True``.  Useful for
    visually separating content sections within rows, columns, or
    cards.

    Example::

        import butterflyui as bui

        sep = bui.Divider(thickness=2, indent=16, color="#334155")

    Args:
        vertical: 
            If ``True`` renders a vertical divider instead of horizontal.
        thickness: 
            Line thickness in logical pixels.
        indent: 
            Leading blank space before the divider line.
        end_indent: 
            Trailing blank space after the divider line.
        color: 
            Divider line colour.
    """
    control_type = "divider"

    def __init__(
        self,
        *,
        vertical: bool | None = None,
        thickness: float | None = None,
        indent: float | None = None,
        end_indent: float | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            vertical=vertical,
            thickness=thickness,
            indent=indent,
            end_indent=end_indent,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
