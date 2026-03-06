from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["HistogramView"]

@butterfly_control('histogram_view')
class HistogramView(LayoutControl):
    """
    Standalone histogram bar chart rendered via ``CustomPaint``.

    Each bin value is drawn as a vertical bar whose height is proportional
    to the value. The default bar colour is ``#60a5fa``. A background
    reference grid is shown when `show_grid` is ``True``. Use ``compact``
    for a shorter chart (``84`` px vs ``140`` px default).

    ```python
    import butterflyui as bui

    bui.HistogramView(
        bins=[0.1, 0.35, 0.7, 0.55, 0.2],
        show_grid=True,
    )
    ```
    """

    bins: list[float] | None = None
    """
    List of bin values (relative bar heights, ``0.0``–``1.0``).
    """

    channels: list[Mapping[str, Any]] | None = None
    """
    Per-channel histograms. Each item is a dict with ``"bins"`` and ``"color"`` keys.
    """

    domain: list[float] | None = None
    """
    Domain range ``[min, max]`` used for axis labelling.
    """

    normalized: bool | None = None
    """
    If ``True``, bin values are normalised to the tallest bin.
    """

    show_grid: bool | None = None
    """
    If ``True``, a background reference grid is drawn.
    """

    compact: bool | None = None
    """
    If ``True``, the chart renders at a shorter height (``84`` px instead of ``140`` px).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `histogram_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `histogram_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `histogram_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `histogram_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `histogram_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `histogram_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `histogram_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `histogram_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `histogram_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `histogram_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `histogram_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `histogram_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `histogram_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `histogram_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `histogram_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `histogram_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `histogram_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `histogram_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `histogram_view` runtime control.
    """

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
