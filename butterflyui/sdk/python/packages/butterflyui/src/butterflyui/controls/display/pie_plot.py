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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `pie_plot` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `pie_plot` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `pie_plot` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `pie_plot` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `pie_plot` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `pie_plot` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `pie_plot` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `pie_plot` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `pie_plot` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `pie_plot` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `pie_plot` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `pie_plot` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `pie_plot` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `pie_plot` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `pie_plot` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `pie_plot` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `pie_plot` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `pie_plot` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `pie_plot` runtime control.
    """

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
