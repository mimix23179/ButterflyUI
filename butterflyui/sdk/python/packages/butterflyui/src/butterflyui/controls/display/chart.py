from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Chart"]

class Chart(Component):
    """Generic chart base that delegates to line or bar painters.

    Renders either a line chart (``_LineChartPainter``) or a bar chart
    (``_BarChartPainter``) depending on the ``chart_type`` value.
    Setting ``chart_type`` to ``"bar"`` or ``"column"`` selects bars;
    any other value (including the default ``"line"``) draws a
    continuous polyline.  When ``fill`` is ``True`` (or chart type is
    ``"area"``) the region under the line is shaded.

    Tapping the chart emits a ``"select"`` event with the nearest
    data-point index and value.

    Example::

        import butterflyui as bui

        chart = bui.Chart(
            values=[3, 7, 2, 9, 5],
            chart_type="line",
            fill=True,
            color="#4f46e5",
        )

    Args:
        values: 
            Numeric data points for the chart.
        points: 
            Alias for ``values``.
        chart_type: 
            ``"line"`` (default), ``"area"``, ``"bar"``, or ``"column"``.
        fill: 
            If ``True`` the area under a line chart is shaded.
        color: 
            Primary colour used by the chart painter.
    """
    control_type = "chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        chart_type: str | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values if values is not None else points,
            points=points if points is not None else values,
            chart_type=chart_type,
            fill=fill,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
