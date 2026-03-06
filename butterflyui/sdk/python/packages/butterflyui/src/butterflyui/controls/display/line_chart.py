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

    color: Any | None = None
    """
    Stroke colour for the line and fill region.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `line_chart` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `line_chart` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `line_chart` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `line_chart` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `line_chart` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `line_chart` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `line_chart` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `line_chart` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `line_chart` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `line_chart` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `line_chart` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `line_chart` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `line_chart` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `line_chart` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `line_chart` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `line_chart` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `line_chart` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `line_chart` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `line_chart` runtime control.
    """

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
