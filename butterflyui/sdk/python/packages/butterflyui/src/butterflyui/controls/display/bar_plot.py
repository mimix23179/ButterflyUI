from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .bar_chart import BarChart

__all__ = ["BarPlot"]

class BarPlot(BarChart):
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

    color: Any | None = None
    """
    Bar colour applied to every bar.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "bar_plot"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        labels: list[str] | None = None,
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
            labels=labels,
            fill=fill,
            color=color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
