from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Box"]

@butterfly_control('box', field_aliases={'content': 'child'})
class Box(LayoutControl, SingleChildControl):
    """
    Simple sized box that constrains and optionally decorates its children.

    The runtime renders a lightweight container. Accepts optional ``width``,
    ``height``, ``padding``, ``margin``, ``alignment``, and ``bgcolor``
    styling values.

    ``Box`` also forwards universal runtime props through ``**kwargs``. This
    includes style/modifier/motion/effects keys plus optional ``icon``,
    ``color``, and ``transparency`` hints used by higher-level styling flows.

    Example:

    ```python
    import butterflyui as bui

    bui.Box(
        bui.Text("Inside a box"),
        width=200,
        height=100,
        bgcolor="#F0F0F0",
        padding=8,
    )
    ```
    """

    image: Any | None = None
    """
    Image descriptor rendered by the control.
    """
