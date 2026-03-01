from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Card"]

class Card(Component):
    """
    Material-style surface container that wraps a single child control
    inside a rounded, optionally elevated panel.

    The runtime renders a Flutter ``Card`` whose background colour falls
    back to the active Candy ``surface`` token, border colour to the
    ``border`` token, and corner radius to the theme's ``card.radius``
    or ``radii.md`` token.  An optional ``content_padding`` is applied as
    inner ``Padding``, and ``content_alignment`` positions the child
    inside the card via ``Align``.

    ```python
    import butterflyui as bui

    bui.Card(
        bui.Text("Hello from a card!"),
        radius=12,
        elevated=True,
        content_padding=16,
    )
    ```

    Args:
        title: 
            Optional primary title text forwarded as metadata in the control props.
        subtitle: 
            Optional secondary title text forwarded as metadata in the control props.
        elevated: 
            If ``True``, applies elevated card styling with a non-zero ``elevation`` value.
        radius: 
            Corner radius in logical pixels.  Overrides the Candy ``card.radius`` / ``radii.md`` tokens.
        content_padding: 
            Inner padding applied around the card's child content (single number or per-edge spec).
    """

    control_type = "card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        subtitle: str | None = None,
        elevated: bool | None = None,
        radius: float | None = None,
        content_padding: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            subtitle=subtitle,
            elevated=elevated,
            radius=radius,
            content_padding=content_padding,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
