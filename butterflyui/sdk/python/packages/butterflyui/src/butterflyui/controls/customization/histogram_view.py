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

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
