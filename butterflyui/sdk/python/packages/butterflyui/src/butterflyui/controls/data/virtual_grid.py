from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["VirtualGrid"]

class VirtualGrid(Component):
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

    Args:
        items: 
            Item payload list used to build tiles when no explicit children are given.
        columns: 
            Number of grid columns.
        spacing: 
            Main-axis spacing in logical pixels between tiles.
        run_spacing: 
            Cross-axis spacing in logical pixels between tile runs.
        child_aspect_ratio: 
            Width-to-height ratio of each tile (e.g. ``1.0`` for square tiles).
        has_more: 
            If ``True``, signals that more data can be requested when nearing the end.
        loading: 
            If ``True``, a loading indicator is displayed at the tail of the grid.
        prefetch_threshold: 
            Number of remaining items at which a ``"prefetch"`` event is emitted.
    """

    control_type = "virtual_grid"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        child_aspect_ratio: float | None = None,
        has_more: bool | None = None,
        loading: bool | None = None,
        prefetch_threshold: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            columns=columns,
            spacing=spacing,
            run_spacing=run_spacing,
            child_aspect_ratio=child_aspect_ratio,
            has_more=has_more,
            loading=loading,
            prefetch_threshold=prefetch_threshold,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
