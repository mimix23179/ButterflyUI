from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["HistogramOverlay"]

@butterfly_control('histogram_overlay')
class HistogramOverlay(LayoutControl):
    """
    Renders a histogram chart layered on top of a child control.

    The runtime stacks the child beneath an ``IgnorePointer`` histogram
    (delegated to the ``HistogramView`` painter) at reduced opacity, so
    the histogram floats over the content without intercepting input.

    ```python
    import butterflyui as bui

    bui.HistogramOverlay(
        my_image,
        bins=[0.1, 0.4, 0.9, 0.6, 0.2],
        opacity=0.45,
    )
    ```
    """

    bins: list[float] | None = None
    """
    List of bin values (relative heights, ``0.0``–``1.0``) that form the histogram bars.
    """

    channels: list[Mapping[str, Any]] | None = None
    """
    Per-channel histogram data. Each item is a dict with keys like ``"bins"`` and ``"color"``.
    """

    blend_mode: str | None = None
    """
    Compositing blend mode used when painting the histogram.
    """

    compact: bool | None = None
    """
    If ``True``, the histogram renders at a shorter height (``84`` px vs ``140`` px).
    """

    show_grid: bool | None = None
    """
    If ``True``, a background reference grid is drawn behind the bars.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `histogram_overlay` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `histogram_overlay` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `histogram_overlay` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `histogram_overlay` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `histogram_overlay` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `histogram_overlay` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `histogram_overlay` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `histogram_overlay` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `histogram_overlay` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `histogram_overlay` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `histogram_overlay` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `histogram_overlay` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `histogram_overlay` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `histogram_overlay` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `histogram_overlay` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `histogram_overlay` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `histogram_overlay` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `histogram_overlay` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `histogram_overlay` runtime control.
    """

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
