from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Sparkline"]

class Sparkline(Component):
    """Compact inline line chart for trend visualisation.

    Renders a small ``CustomPaint`` polyline (default height 40 px)
    using ``_LineChartPainter``.  Intended for dashboard cells,
    table rows, or anywhere a quick numeric trend is needed.  When
    ``fill`` is ``True`` the area under the line is shaded at
    reduced opacity.

    Use ``set_data`` to update the data points at runtime.

    Example::

        import butterflyui as bui

        spark = bui.Sparkline(
            values=[3, 7, 4, 8, 2, 6],
            color="#4f46e5",
            fill=True,
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
    """
    control_type = "sparkline"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
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
            fill=fill,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
