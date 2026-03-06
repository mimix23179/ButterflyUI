from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Chart"]

@butterfly_control('chart')
class Chart(LayoutControl):
    """
    Generic chart base that delegates to line or bar painters.

    Renders either a line chart (``_LineChartPainter``) or a bar chart
    (``_BarChartPainter``) depending on the ``chart_type`` value.
    Setting ``chart_type`` to ``"bar"`` or ``"column"`` selects bars;
    any other value (including the default ``"line"``) draws a
    continuous polyline.  When ``fill`` is ``True`` (or chart type is
    ``"area"``) the region under the line is shaded.

    Tapping the chart emits a ``"select"`` event with the nearest
    data-point index and value.

    Example:

    ```python
    import butterflyui as bui

    chart = bui.Chart(
        values=[3, 7, 2, 9, 5],
        chart_type="line",
        fill=True,
        color="#4f46e5",
    )
    ```
    """

    values: list[Any] | None = None
    """
    Numeric data points for the chart.
    """

    points: list[Any] | None = None
    """
    Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
    """

    chart_type: str | None = None
    """
    ``"line"`` (default), ``"area"``, ``"bar"``, or ``"column"``.
    """

    fill: bool | None = None
    """
    Controls whether the area under a line chart is shaded. Set it to ``False`` to disable this behavior.
    """
