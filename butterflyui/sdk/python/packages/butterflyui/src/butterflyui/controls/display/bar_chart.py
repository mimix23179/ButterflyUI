from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BarChart"]

class BarChart(Component):
    """Vertical bar chart rendered with ``CustomPaint``.

    Draws one or more series of vertical bars using a lightweight
    ``CustomPainter``.  Single-series data is passed via ``values``;
    multi-series data uses ``datasets`` (a list of dicts with a
    ``"values"`` key).  When ``stacked`` is ``True`` multiple series
    are stacked on top of each other; when ``grouped`` is ``True``
    they sit side-by-side.  Tapping a bar area emits a ``"select"``
    event containing the bar index and value.

    Use ``set_data`` to replace the chart data at runtime.

    Example::

        import butterflyui as bui

        chart = bui.BarChart(
            values=[12, 25, 18, 30, 22],
            labels=["Mon", "Tue", "Wed", "Thu", "Fri"],
            color="#2563eb",
        )

    Args:
        values: 
            Primary list of numeric bar values.
        points: 
            Alias for ``values``.
        labels: 
            Category labels displayed along the x-axis.
        datasets: 
            List of dataset mappings, each containing a ``"values"`` key, for multi-series bar charts.
        grouped: 
            If ``True`` multiple datasets are drawn side-by-side.
        stacked: 
            If ``True`` datasets are stacked vertically.
        fill: 
            Whether bars are solid-filled (default ``True``).
        color: 
            Primary bar colour forwarded to the painter.
        animate: 
            If ``True`` the runtime animates data transitions.
        show_tooltip: 
            If ``True`` a tooltip appears on bar hover.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "bar_chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        labels: list[str] | None = None,
        datasets: list[Mapping[str, Any]] | None = None,
        grouped: bool | None = None,
        stacked: bool | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        animate: bool | None = None,
        show_tooltip: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values if values is not None else points,
            points=points if points is not None else values,
            labels=labels,
            datasets=[dict(item) for item in (datasets or [])],
            grouped=grouped,
            stacked=stacked,
            chart_type="bar",
            fill=fill,
            color=color,
            animate=animate,
            show_tooltip=show_tooltip,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_data(
        self,
        session: Any,
        values: list[Any],
        labels: list[str] | None = None,
        datasets: list[Mapping[str, Any]] | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {"values": values, "labels": labels}
        if datasets is not None:
            payload["datasets"] = [dict(item) for item in datasets]
        return self.invoke(session, "set_data", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
