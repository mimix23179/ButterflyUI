from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Grid"]

class Grid(Component):
    """
    Grid layout that arranges children into a fixed number of columns.

    The runtime renders a Flutter ``GridView.count``. ``columns`` sets the
    cross-axis count; ``spacing`` and ``run_spacing`` add gaps between cells.
    ``child_aspect_ratio`` fixes each cell's width-to-height ratio.
    ``direction`` switches between vertical and horizontal scrolling.
    ``shrink_wrap`` sizes the grid to its content instead of filling the parent.

    ```python
    import butterflyui as bui

    bui.Grid(
        items=[{"label": "A"}, {"label": "B"}, {"label": "C"}],
        columns=3,
        spacing=8,
        child_aspect_ratio=1.0,
        events=["select"],
    )
    ```

    Args:
        items:
            List of item spec mappings rendered as grid cells.
        columns:
            Number of columns (cross-axis cell count).
        spacing:
            Horizontal gap between cells in logical pixels.
        run_spacing:
            Vertical gap between rows in logical pixels.
        child_aspect_ratio:
            Width-to-height ratio for each cell. Defaults to ``1.0``.
        direction:
            Scroll axis. Values: ``"vertical"`` (default), ``"horizontal"``.
        reverse:
            When ``True`` items are laid out in reverse order.
        shrink_wrap:
            When ``True`` the grid sizes itself to its content.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "grid"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        child_aspect_ratio: float | None = None,
        direction: str | None = None,
        reverse: bool | None = None,
        shrink_wrap: bool | None = None,
        events: list[str] | None = None,
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
            direction=direction,
            reverse=reverse,
            shrink_wrap=shrink_wrap,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
