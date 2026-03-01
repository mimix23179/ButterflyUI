from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .bar_chart import BarChart

__all__ = ["BarPlot"]

class BarPlot(BarChart):
    """Simplified bar-chart alias for quick single-series plots.

    Extends ``BarChart`` with a reduced parameter set tailored for
    single-series data.  Multi-series features (``datasets``,
    ``grouped``, ``stacked``) are omitted — pass ``values`` and an
    optional ``color`` for a one-liner bar plot.

    Example::

        import butterflyui as bui

        plot = bui.BarPlot(
            values=[4, 8, 15, 16, 23, 42],
            color="#7c3aed",
        )

    Args:
        values: 
            Numeric bar values for a single series.
        points: 
            Alias for ``values``.
        labels: 
            Category labels for each bar.
        fill: 
            Whether bars are solid-filled.
        color: 
            Bar colour applied to every bar.
        events:
            List of event names the Flutter runtime should emit to Python.
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
