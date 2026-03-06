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
            Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
        fill:
            Controls whether the area under the line is filled. Set it to ``False`` to disable this behavior.
        color:
            Primary color value used by the control for text, icons, strokes, or accent surfaces.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
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

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
