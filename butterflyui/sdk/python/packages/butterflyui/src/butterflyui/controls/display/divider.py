from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Divider"]

class Divider(Component):
    """
    Thin horizontal or vertical line separator.
    
    Renders a Material ``Divider`` (horizontal by default) or
    ``VerticalDivider`` when ``vertical`` is ``True``.  Useful for
    visually separating content sections within rows, columns, or
    cards.
    
    Example:
    
    ```python
    import butterflyui as bui

    sep = bui.Divider(thickness=2, indent=16, color="#334155")
    ```
    """


    vertical: bool | None = None
    """
    Controls whether renders a vertical divider instead of horizontal. Set it to ``False`` to disable this behavior.
    """

    thickness: float | None = None
    """
    Line thickness in logical pixels.
    """

    indent: float | None = None
    """
    Leading blank space before the divider line.
    """

    end_indent: float | None = None
    """
    Trailing blank space after the divider line.
    """

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
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
