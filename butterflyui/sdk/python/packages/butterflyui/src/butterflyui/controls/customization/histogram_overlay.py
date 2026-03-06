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

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
