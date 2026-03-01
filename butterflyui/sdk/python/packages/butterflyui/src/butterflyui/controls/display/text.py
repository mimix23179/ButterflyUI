from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Text"]

class Text(Component):
    """Simple text label.

    Renders a Flutter ``Text`` widget from the ``value`` or ``text``
    parameter.  The value is coerced to a string.  Additional
    typographic options (font size, weight, colour, etc.) can be
    passed through ``props`` or ``**kwargs``.

    Example::

        import butterflyui as bui

        label = bui.Text("Hello, world!")

    Args:
        value: 
            Text content to display (coerced to ``str``).
        text: 
            Alias for ``value`` — takes precedence when both are supplied.
    """
    control_type = "text"

    def __init__(
        self,
        value: Any = "",
        *,
        text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else str(value)
        merged = merge_props(props, text=resolved, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
