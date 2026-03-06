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

    animate: bool | None = None
    """
    Controls whether the runtime animates data transitions. Set it to ``False`` to disable this behavior.
    """

    show_tooltip: bool | None = None
    """
    Controls whether a tooltip appears on bar hover. Set it to ``False`` to disable this behavior.
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
