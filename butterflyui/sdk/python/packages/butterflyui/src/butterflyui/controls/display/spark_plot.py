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
            Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
        fill:
            Controls whether the area under the line is shaded. Set it to ``False`` to disable this behavior.
        color:
            Primary color value used by the control for text, icons, strokes, or accent surfaces.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
    """


    values: list[Any] | None = None
    """
    Numeric data points for the sparkline.
    """

    points: list[Any] | None = None
    """
    Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
    """

    fill: bool | None = None
    """
    Controls whether the area under the line is shaded. Set it to ``False`` to disable this behavior.
    """

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """


    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
        merged = merge_props(props, events=events)
        super().__init__(
            values=values,
            points=points,
            fill=fill,
            color=color,
            props=merged,
            style=style,
            strict=strict,
            **kwargs,
        )
