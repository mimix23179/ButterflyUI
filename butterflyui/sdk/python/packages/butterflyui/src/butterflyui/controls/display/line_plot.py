from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .line_chart import LineChart

__all__ = ["LinePlot"]

class LinePlot(LineChart):
    """Simplified line-chart alias for quick single-series plots.

    Extends ``LineChart`` with an identical parameter surface.  Use
    this when you want a semantic distinction (e.g. a scientific
    "plot" vs. a dashboard "chart") without any behavioural
    difference.

    Example::

        import butterflyui as bui

        plot = bui.LinePlot(
            values=[1.2, 3.4, 2.1, 5.6],
            color="#059669",
        )

    Args:
        values: 
            Numeric data points for the polyline.
        points: 
            Alias for ``values``.
        fill: 
            If ``True`` the area under the line is filled.
        color: 
            Stroke colour for the line.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "line_plot"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            values=values,
            points=points,
            fill=fill,
            color=color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
