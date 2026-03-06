from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Surface"]

@butterfly_control('surface', field_aliases={'content': 'child'})
class Surface(LayoutControl, SingleChildControl):
    """
    Elevated surface card with background color, border, and corner radius.

    A simplified decorated container for material-style surfaces. Accepts
    ``padding`` for inner spacing, ``radius`` for corner rounding, ``bgcolor``
    for the background fill, and ``border_color``/``border_width`` for an
    optional border stroke.

    ``Surface`` participates in the universal styling/effects pipeline exposed
    by the shared renderer. You can pass the same cross-control props used by
    Candy/Skins/Style/Modifier/Gallery through ``**kwargs`` (for example
    ``variant``, ``classes``, ``modifiers``, ``motion``, ``effects``,
    ``on_hover_modifiers``, ``icon``, ``color``, ``transparency``).

    Example:

    ```python
    import butterflyui as bui

    bui.Surface(
        bui.Text("Card content"),
        radius=12,
        bgcolor="#FFFFFF",
        padding=16,
    )
    ```
    """
