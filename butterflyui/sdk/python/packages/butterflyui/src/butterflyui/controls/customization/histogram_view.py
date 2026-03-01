from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["HistogramView"]

class HistogramView(Component):
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

    Args:
        bins: 
            List of bin values (relative bar heights, ``0.0``–``1.0``).
        channels: 
            Per-channel histograms. Each item is a dict with ``"bins"`` and ``"color"`` keys.
        domain: 
            Domain range ``[min, max]`` used for axis labelling.
        normalized: 
            If ``True``, bin values are normalised to the tallest bin.
        show_grid: 
            If ``True``, a background reference grid is drawn.
        compact: 
            If ``True``, the chart renders at a shorter height (``84`` px instead of ``140`` px).
        height: 
            Explicit canvas height in logical pixels. Overrides ``compact`` when set.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "histogram_view"

    def __init__(
        self,
        *,
        bins: list[float] | None = None,
        channels: list[Mapping[str, Any]] | None = None,
        domain: list[float] | None = None,
        normalized: bool | None = None,
        show_grid: bool | None = None,
        compact: bool | None = None,
        height: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            bins=bins,
            channels=[dict(channel) for channel in (channels or [])],
            domain=domain,
            normalized=normalized,
            show_grid=show_grid,
            compact=compact,
            height=height,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
