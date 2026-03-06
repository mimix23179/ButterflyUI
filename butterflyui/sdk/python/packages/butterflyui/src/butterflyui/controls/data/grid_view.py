from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
from ..items_control import ItemsControl
__all__ = ["GridView"]

@butterfly_control('grid_view', field_aliases={'controls': 'children'})
class GridView(ScrollableControl, MultiChildControl, ItemsControl):
    """
    Multi-column grid layout that arranges child controls or item
    payloads into a configurable number of columns.

    When explicit ``children`` are supplied they are rendered directly as
    grid tiles.  Alternatively, an ``items`` payload list can be passed
    to let the runtime build tiles from data.  The ``columns`` parameter
    controls how many tiles appear per row.

    ```python
    import butterflyui as bui

    bui.GridView(
        bui.Text("A"), bui.Text("B"), bui.Text("C"), bui.Text("D"),
        columns=2,
    )
    ```
    """

    columns: int | None = None
    """
    Number of grid columns.  Defaults to the runtime's layout heuristic when ``None``.
    """
