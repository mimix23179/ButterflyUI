from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["PiePlot"]

class PiePlot(Component):
    """Pie or donut chart rendered with ``CustomPaint``.

    Draws coloured arc segments proportional to ``values`` using a
    ``CustomPainter``.  When ``donut`` is ``True`` (or ``hole`` > 0)
    a circular cut-out is drawn in the centre.  The chart cycles
    through ``colors`` (or a built-in palette) for each segment.

    Tapping the chart emits a ``"tap"`` event with local coordinates.

    Example::

        import butterflyui as bui

        pie = bui.PiePlot(
            values=[40, 30, 20, 10],
            labels=["A", "B", "C", "D"],
            donut=True,
        )

    Args:
        values: 
            Numeric values for each pie segment.
        labels: 
            Optional labels for each segment.
        colors: 
            List of colours cycled across segments.  Defaults to a built-in five-colour palette.
        donut: 
            If ``True`` a hole is drawn in the centre.
        hole: 
            Ratio of the hole radius to the outer radius (``0.0``\u2013``0.9``; default ``0.55``).
        start_angle: 
            Start angle in degrees (default ``-90``).
        clockwise: 
            If ``True`` segments are drawn clockwise.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "pie_plot"

    def __init__(
        self,
        *,
        values: list[float] | None = None,
        labels: list[str] | None = None,
        colors: list[Any] | None = None,
        donut: bool | None = None,
        hole: float | None = None,
        start_angle: float | None = None,
        clockwise: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values,
            labels=labels,
            colors=colors,
            donut=donut,
            hole=hole,
            start_angle=start_angle,
            clockwise=clockwise,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
