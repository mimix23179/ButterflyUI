from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Stack"]

@butterfly_control('stack', field_aliases={'controls': 'children'})
class Stack(LayoutControl, MultiChildControl):
    """
    Overlapping-children container that layers widgets on top of each other.

    The runtime wraps Flutter's ``Stack`` widget. ``alignment`` positions
    un-positioned children within the stack bounds. ``fit`` controls how the
    stack sizes itself: ``"loose"`` (shrink to the largest child) or
    ``"expand"`` (fills the parent). ``clip`` enables clipping of children
    that overflow the stack bounds.

    Example:

    ```python
    import butterflyui as bui

    bui.Stack(
        bui.Image(src="background.png"),
        bui.Text("Overlay text"),
        alignment="center",
    )
    ```
    """

    fit: str | None = None
    """
    How the stack sizes itself. Values: ``"loose"``, ``"expand"``.
    """

    clip: bool | None = None
    """
    When ``True`` children that overflow the stack bounds are clipped.
    """
