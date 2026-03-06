from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["BarChart"]

@butterfly_control('bar_chart')
class BarChart(LayoutControl):
    """
    Vertical bar chart rendered with ``CustomPaint``.

    Draws one or more series of vertical bars using a lightweight
    ``CustomPainter``.  Single-series data is passed via ``values``;
    multi-series data uses ``datasets`` (a list of dicts with a
    ``"values"`` key).  When ``stacked`` is ``True`` multiple series
    are stacked on top of each other; when ``grouped`` is ``True``
    they sit side-by-side.  Tapping a bar area emits a ``"select"``
    event containing the bar index and value.

    Use ``set_data`` to replace the chart data at runtime.

    Example:

    ```python
    import butterflyui as bui

    chart = bui.BarChart(
        values=[12, 25, 18, 30, 22],
        labels=["Mon", "Tue", "Wed", "Thu", "Fri"],
        color="#2563eb",
    )
    ```
    """

    values: list[Any] | None = None
    """
    Primary list of numeric bar values.
    """

    points: list[Any] | None = None
    """
    Backward-compatible alias for ``values``. When both fields are provided, ``values`` takes precedence and this alias is kept only for compatibility.
    """

    labels: list[str] | None = None
    """
    Category labels displayed along the x-axis.
    """

    datasets: list[Mapping[str, Any]] | None = None
    """
    List of dataset mappings, each containing a ``"values"`` key, for multi-series bar charts.
    """

    grouped: bool | None = None
    """
    Controls whether multiple datasets are drawn side-by-side. Set it to ``False`` to disable this behavior.
    """

    stacked: bool | None = None
    """
    Controls whether datasets are stacked vertically. Set it to ``False`` to disable this behavior.
    """

    fill: bool | None = None
    """
    Whether bars are solid-filled (default ``True``).
    """

    color: Any | None = None
    """
    Primary bar colour forwarded to the painter.
    """

    animate: bool | None = None
    """
    Controls whether the runtime animates data transitions. Set it to ``False`` to disable this behavior.
    """

    show_tooltip: bool | None = None
    """
    Controls whether a tooltip appears on bar hover. Set it to ``False`` to disable this behavior.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `bar_chart` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `bar_chart` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `bar_chart` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `bar_chart` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `bar_chart` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `bar_chart` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `bar_chart` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `bar_chart` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `bar_chart` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `bar_chart` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `bar_chart` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `bar_chart` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `bar_chart` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `bar_chart` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `bar_chart` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `bar_chart` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `bar_chart` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `bar_chart` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `bar_chart` runtime control.
    """

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
