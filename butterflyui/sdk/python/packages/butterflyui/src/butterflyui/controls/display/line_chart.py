from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .chart import Chart

__all__ = ["LineChart"]

class LineChart(Chart):
    """Line chart with optional area fill.

    Extends ``Chart`` and forces ``chart_type`` to ``"line"``.  Data
    is drawn as a continuous polyline using ``_LineChartPainter``.
    When ``fill`` is ``True`` the area under the curve is shaded at
    20% opacity.  Tapping the chart emits a ``"select"`` event with
    the nearest data-point index and value.

    Use ``set_data`` to replace the data series at runtime.

    Example::

        import butterflyui as bui

        chart = bui.LineChart(
            values=[10, 42, 28, 55, 33],
            fill=True,
            color="#4f46e5",
        )

    Args:
        values: 
            Numeric data points for the polyline.
        points: 
            Alias for ``values``.
        fill: 
            If ``True`` the area under the line is filled.
        color: 
            Stroke colour for the line and fill region.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "line_chart"

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
            chart_type="line",
            fill=fill,
            color=color,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
