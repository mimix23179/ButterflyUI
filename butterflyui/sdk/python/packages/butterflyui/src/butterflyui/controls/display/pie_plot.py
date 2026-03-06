from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["PiePlot"]

@butterfly_control('pie_plot')
class PiePlot(LayoutControl):
    """
    Pie or donut chart rendered with ``CustomPaint``.

    Draws coloured arc segments proportional to ``values`` using a
    ``CustomPainter``.  When ``donut`` is ``True`` (or ``hole`` > 0)
    a circular cut-out is drawn in the centre.  The chart cycles
    through ``colors`` (or a built-in palette) for each segment.

    Tapping the chart emits a ``"tap"`` event with local coordinates.

    Example:

    ```python
    import butterflyui as bui

    pie = bui.PiePlot(
        values=[40, 30, 20, 10],
        labels=["A", "B", "C", "D"],
        donut=True,
    )
    ```
    """

    values: list[float] | None = None
    """
    Numeric values for each pie segment.
    """

    labels: list[str] | None = None
    """
    Optional labels for each segment.
    """

    colors: list[Any] | None = None
    """
    List of colours cycled across segments.  Defaults to a built-in five-colour palette.
    """

    donut: bool | None = None
    """
    Controls whether a hole is drawn in the centre. Set it to ``False`` to disable this behavior.
    """

    hole: float | None = None
    """
    Ratio of the hole radius to the outer radius (``0.0``–``0.9``; default ``0.55``).
    """

    start_angle: float | None = None
    """
    Start angle in degrees (default ``-90``).
    """

    clockwise: bool | None = None
    """
    Controls whether segments are drawn clockwise. Set it to ``False`` to disable this behavior.
    """

    inner_radius: Any | None = None
    """
    Inner radius value forwarded to the `pie_plot` runtime control.
    """

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
