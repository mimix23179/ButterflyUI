from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MessageDivider"]

class MessageDivider(Component):
    """Horizontal divider with an optional centred label.

    Renders a ``Row`` with two ``Divider`` lines separated by an
    optional ``label`` text.  Commonly used inside chat threads to
    mark date boundaries or unread-message markers.  Colour, text
    colour, and padding are all configurable.

    Example::

        import butterflyui as bui

        div = bui.MessageDivider(
            label="Today",
            color="#ffffff3d",
            text_color="#ffffffb3",
        )

    Args:
        label: 
            Optional centred text between the two divider lines.
        padding: 
            Vertical padding around the divider row.
        color: 
            Colour of the horizontal divider lines.
        text_color: 
            Colour of the centred label text.
    """
    control_type = "message_divider"

    def __init__(
        self,
        label: str | None = None,
        *,
        padding: Any | None = None,
        color: Any | None = None,
        text_color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            padding=padding,
            color=color,
            text_color=text_color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
