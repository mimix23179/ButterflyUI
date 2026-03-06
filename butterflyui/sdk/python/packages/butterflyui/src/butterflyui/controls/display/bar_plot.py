from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .bar_chart import BarChart
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BarPlot"]

@butterfly_control('bar_plot')
class BarPlot(LayoutControl):
    """
    Simplified bar-chart alias for quick single-series plots.

    Extends ``BarChart`` with a reduced parameter set tailored for
    single-series data.  Multi-series features (``datasets``,
    ``grouped``, ``stacked``) are omitted — pass ``values`` and an
    optional ``color`` for a one-liner bar plot.

    Example:

    ```python
    import butterflyui as bui

    plot = bui.BarPlot(
        values=[4, 8, 15, 16, 23, 42],
        color="#7c3aed",
    )
    ```
    """

    values: list[Any] | None = None
    """
    Numeric bar values for a single series.
    """

    points: list[Any] | None = None
    """
    Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
    """

    labels: list[str] | None = None
    """
    Ordered list of label strings rendered by the control.
    """

    fill: bool | None = None
    """
    Fill color or paint descriptor used when rendering the chart or visual surface.
    """

    colors: Any | None = None
    """
    Colors value forwarded to the `bar_plot` runtime control.
    """

    max: Any | None = None
    """
    Maximum value or count accepted by the control.
    """

    min: Any | None = None
    """
    Minimum value or count accepted by the control.
    """

    spacing: Any | None = None
    """
    Spacing between repeated child elements.
    """
