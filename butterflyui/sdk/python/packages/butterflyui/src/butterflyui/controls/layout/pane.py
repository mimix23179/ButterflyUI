from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
from ..title_control import TitleControl
__all__ = ["Pane"]

@butterfly_control('pane', field_aliases={'content': 'child'})
class Pane(LayoutControl, SingleChildControl, TitleControl):
    """
    Named pane for use inside a slot-based layout such as ``DockLayout``.

    Declares a slot-addressed pane. The ``slot`` string tells the parent
    layout where to place this pane (e.g. ``"top"``, ``"left"``,
    ``"fill"``). ``title`` labels the pane in containers that show titles.
    ``size``, ``width``, and ``height`` hint at the preferred dimensions.

    Example:

    ```python
    import butterflyui as bui

    bui.Pane(
        bui.Text("Sidebar"),
        slot="left",
        size=240,
    )
    ```
    """

    slot: str | None = None
    """
    Slot identifier that controls placement within the parent layout.
    """
