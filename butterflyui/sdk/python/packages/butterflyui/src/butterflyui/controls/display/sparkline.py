from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Sparkline"]

@butterfly_control('sparkline')
class Sparkline(LayoutControl):
    """
    Compact inline line chart for trend visualisation.

    Renders a small ``CustomPaint`` polyline (default height 40 px)
    using ``_LineChartPainter``.  Intended for dashboard cells,
    table rows, or anywhere a quick numeric trend is needed.  When
    ``fill`` is ``True`` the area under the line is shaded at
    reduced opacity.

    Use ``set_data`` to update the data points at runtime.

    Example:

    ```python
    import butterflyui as bui

    spark = bui.Sparkline(
        values=[3, 7, 4, 8, 2, 6],
        color="#4f46e5",
        fill=True,
    )
    ```
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

    foreground: Any | None = None
    """
    Foreground value forwarded to the `sparkline` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `sparkline` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `sparkline` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `sparkline` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `sparkline` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `sparkline` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `sparkline` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `sparkline` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `sparkline` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `sparkline` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `sparkline` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `sparkline` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `sparkline` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `sparkline` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `sparkline` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `sparkline` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `sparkline` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `sparkline` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `sparkline` runtime control.
    """

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
