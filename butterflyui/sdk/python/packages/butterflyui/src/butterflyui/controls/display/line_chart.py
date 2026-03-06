from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .chart import Chart
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["LineChart"]

@butterfly_control('line_chart')
class LineChart(LayoutControl):
    """
    Line chart with optional area fill.

    Extends ``Chart`` and forces ``chart_type`` to ``"line"``.  Data
    is drawn as a continuous polyline using ``_LineChartPainter``.
    When ``fill`` is ``True`` the area under the curve is shaded at
    20% opacity.  Tapping the chart emits a ``"select"`` event with
    the nearest data-point index and value.

    Use ``set_data`` to replace the data series at runtime.

    Example:

    ```python
    import butterflyui as bui

    chart = bui.LineChart(
        values=[10, 42, 28, 55, 33],
        fill=True,
        color="#4f46e5",
    )
    ```
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

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
