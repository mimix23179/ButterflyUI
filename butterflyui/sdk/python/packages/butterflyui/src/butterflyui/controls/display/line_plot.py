from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .line_chart import LineChart
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["LinePlot"]

@butterfly_control('line_plot')
class LinePlot(LayoutControl):
    """
    Simplified line-chart alias for quick single-series plots.

    Extends ``LineChart`` with an identical parameter surface.  Use
    this when you want a semantic distinction (e.g. a scientific
    "plot" vs. a dashboard "chart") without any behavioural
    difference.

    Example:

    ```python
    import butterflyui as bui

    plot = bui.LinePlot(
        values=[1.2, 3.4, 2.1, 5.6],
        color="#059669",
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
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """

    fill_color: Any | None = None
    """
    Fill color value forwarded to the `line_plot` runtime control.
    """

    max: Any | None = None
    """
    Maximum value or count accepted by the control.
    """

    min: Any | None = None
    """
    Minimum value or count accepted by the control.
    """

    stroke_width: Any | None = None
    """
    Stroke width value forwarded to the `line_plot` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `line_plot` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `line_plot` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `line_plot` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `line_plot` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `line_plot` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `line_plot` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `line_plot` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `line_plot` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `line_plot` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `line_plot` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `line_plot` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `line_plot` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `line_plot` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `line_plot` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `line_plot` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `line_plot` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `line_plot` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `line_plot` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `line_plot` runtime control.
    """
