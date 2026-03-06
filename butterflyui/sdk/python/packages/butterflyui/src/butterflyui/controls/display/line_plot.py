from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .line_chart import LineChart
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["LinePlot"]

@butterfly_control('line_plot')
class LinePlot(LayoutControl):
    """
    Simplified line-chart alias for quick single-series plots.

    Extends ``LineChart`` with an identical parameter surface.  Use
    this when you want a semantic distinction (e.g. a scientific
    "plot" vs. a dashboard "chart") without any behavioural
    difference.

    Example:

    ```python
    import butterflyui as bui

    plot = bui.LinePlot(
        values=[1.2, 3.4, 2.1, 5.6],
        color="#059669",
    )
    ```
    """

    values: list[Any] | None = None
    """
    Numeric data points for the polyline.
    """

    points: list[Any] | None = None
    """
    Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
    """

    fill: bool | None = None
    """
    Controls whether the area under the line is filled. Set it to ``False`` to disable this behavior.
    """

    fill_color: Any | None = None
    """
    Fill color value forwarded to the `line_plot` runtime control.
    """

    max: Any | None = None
    """
    Maximum value or count accepted by the control.
    """

    min: Any | None = None
    """
    Minimum value or count accepted by the control.
    """

    stroke_width: Any | None = None
    """
    Stroke width value forwarded to the `line_plot` runtime control.
    """
