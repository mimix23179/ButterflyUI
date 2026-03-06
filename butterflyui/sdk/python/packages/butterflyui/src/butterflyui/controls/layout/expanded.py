from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Expanded"]

@butterfly_control('expanded', field_aliases={'content': 'child'})
class Expanded(LayoutControl, SingleChildControl):
    """
    Expands a child to fill remaining space inside a ``Row``, ``Column``, or ``Flex``.

    The runtime wraps Flutter's ``Expanded`` widget. ``flex`` determines the
    proportion of available space allocated to this child relative to sibling
    flex children. ``fit`` controls how the child is sized into the allocated
    space: ``"tight"`` forces the child to fill, ``"loose"`` allows it to be
    smaller.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Fixed"),
        bui.Expanded(bui.Text("Fill remaining"), flex=1),
    )
    ```
    """

    fit: str | None = None
    """
    How the child fills the allocated space. Values: ``"tight"``
    (fill exactly), ``"loose"`` (at most the allocated size).
    """
