from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .sparkline import Sparkline

__all__ = ["SparkPlot"]

class SparkPlot(Sparkline):
    """Alias for ``Sparkline`` with event subscription support.

    Extends ``Sparkline`` with an explicit ``events`` parameter for
    subscribing to runtime events.  Behaviour is otherwise identical.

    Example::

        import butterflyui as bui

        plot = bui.SparkPlot(
            values=[1, 4, 2, 5, 3],
            color="#059669",
        )

    Args:
        values: 
            Numeric data points for the sparkline.
        points: 
            Alias for ``values``.
        fill: 
            If ``True`` the area under the line is shaded.
        color: 
            Stroke colour for the polyline.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "spark_plot"

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
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )
