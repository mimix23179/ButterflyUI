from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .sparkline import Sparkline
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["SparkPlot"]

@butterfly_control('spark_plot')
class SparkPlot(LayoutControl):
    """
    Alias for ``Sparkline`` with event subscription support.

    Extends ``Sparkline`` with an explicit ``events`` parameter for
    subscribing to runtime events.  Behaviour is otherwise identical.

    Example:

    ```python
    import butterflyui as bui

    plot = bui.SparkPlot(
        values=[1, 4, 2, 5, 3],
        color="#059669",
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
    Stroke width value forwarded to the `spark_plot` runtime control.
    """
