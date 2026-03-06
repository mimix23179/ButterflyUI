from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Grid"]

@butterfly_control('grid', field_aliases={'controls': 'children'})
class Grid(LayoutControl, MultiChildControl):
    """
    Grid layout that arranges children into a fixed number of columns.

    The runtime renders a Flutter ``GridView.count``. ``columns`` sets the
    cross-axis count; ``spacing`` and ``run_spacing`` add gaps between cells.
    ``child_aspect_ratio`` fixes each cell's width-to-height ratio.
    ``direction`` switches between vertical and horizontal scrolling.
    ``shrink_wrap`` sizes the grid to its content instead of filling the parent.

    Example:

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
    """

    columns: int | None = None
    """
    Number of columns (cross-axis cell count).
    """

    spacing: float | None = None
    """
    Horizontal gap between cells in logical pixels.
    """

    run_spacing: float | None = None
    """
    Vertical gap between rows in logical pixels.
    """

    child_aspect_ratio: float | None = None
    """
    Width-to-height ratio for each cell. Defaults to ``1.0``.
    """

    direction: str | None = None
    """
    Scroll axis. Values: ``"vertical"`` (default), ``"horizontal"``.
    """

    reverse: bool | None = None
    """
    When ``True`` items are laid out in reverse order.
    """

    shrink_wrap: bool | None = None
    """
    When ``True`` the grid sizes itself to its content.
    """

    layout: Any | None = None
    """
    Layout value forwarded to the `grid` runtime control.
    """

    masonry: Any | None = None
    """
    Masonry value forwarded to the `grid` runtime control.
    """

    scrollable: Any | None = None
    """
    Whether the control should render inside a scrollable viewport.
    """

    virtual: Any | None = None
    """
    Virtual value forwarded to the `grid` runtime control.
    """

    virtualized: Any | None = None
    """
    Virtualized value forwarded to the `grid` runtime control.
    """
