from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["VirtualGrid"]

@butterfly_control('virtual_grid', field_aliases={'controls': 'children'})
class VirtualGrid(ScrollableControl, MultiChildControl):
    """
    Virtualized grid view for large datasets with prefetch-near-end
    and loading-state support.

    Items are arranged into ``columns`` columns.  ``spacing`` and
    ``run_spacing`` control the gap between tiles along the main and
    cross axes respectively, while ``child_aspect_ratio`` sets the
    width/height ratio per tile.  When ``has_more`` is ``True`` and
    the user scrolls within ``prefetch_threshold`` items of the end,
    a ``"prefetch"`` event is emitted so the app can append more data.
    Setting ``loading`` to ``True`` displays a loading indicator at the
    grid’s tail.

    ```python
    import butterflyui as bui

    bui.VirtualGrid(
        items=[{"label": f"Tile {i}"} for i in range(100)],
        columns=3,
        spacing=8,
        child_aspect_ratio=1.0,
        has_more=True,
        prefetch_threshold=10,
    )
    ```
    """

    columns: int | None = None
    """
    Number of columns used when the control lays out content in a grid.
    """

    spacing: float | None = None
    """
    Main-axis spacing in logical pixels between tiles.
    """

    run_spacing: float | None = None
    """
    Cross-axis spacing in logical pixels between tile runs.
    """

    child_aspect_ratio: float | None = None
    """
    Width-to-height ratio of each tile (e.g. ``1.0`` for square tiles).
    """

    has_more: bool | None = None
    """
    If ``True``, signals that more data can be requested when nearing the end.
    """

    loading: bool | None = None
    """
    If ``True``, a loading indicator is displayed at the tail of the grid.
    """

    prefetch_threshold: int | None = None
    """
    Number of remaining items at which a ``"prefetch"`` event is emitted.
    """
