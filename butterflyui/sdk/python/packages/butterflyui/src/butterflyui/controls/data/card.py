from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Card"]

@butterfly_control('card', field_aliases={'content': 'child'})
class Card(LayoutControl, SingleChildControl):
    """
    Material-style surface container that wraps a single child control
    inside a rounded, optionally elevated panel.

    The runtime renders a Flutter ``Card`` with background colour, border,
    radius, and optional elevation. An optional ``content_padding`` is applied
    as inner ``Padding``, and ``content_alignment`` positions the child inside
    the card via ``Align``.

    ```python
    import butterflyui as bui

    bui.Card(
        bui.Text("Hello from a card!"),
        radius=12,
        elevated=True,
        content_padding=16,
    )
    ```
    """

    elevated: bool | None = None
    """
    If ``True``, applies elevated card styling with a non-zero ``elevation`` value.
    """

    content_padding: Any | None = None
    """
    Inner padding applied around the card's child content (single number or per-edge spec).
    """

    surface_tint_color: Any | None = None
    """
    Surface tint color value forwarded to the `card` runtime control.
    """
