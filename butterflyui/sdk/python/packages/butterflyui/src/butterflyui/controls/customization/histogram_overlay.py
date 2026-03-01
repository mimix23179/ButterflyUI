from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["HistogramOverlay"]

class HistogramOverlay(Component):
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

    Args:
        bins: 
            List of bin values (relative heights, ``0.0``–``1.0``) that form the histogram bars.
        channels: 
            Per-channel histogram data. Each item is a dict with keys like ``"bins"`` and ``"color"``.
        opacity: 
            Opacity of the histogram overlay, ``0.0``–``1.0``. Defaults to ``0.45``.
        blend_mode: 
            Compositing blend mode used when painting the histogram.
        compact: 
            If ``True``, the histogram renders at a shorter height (``84`` px vs ``140`` px).
        show_grid: 
            If ``True``, a background reference grid is drawn behind the bars.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "histogram_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        bins: list[float] | None = None,
        channels: list[Mapping[str, Any]] | None = None,
        opacity: float | None = None,
        blend_mode: str | None = None,
        compact: bool | None = None,
        show_grid: bool | None = None,
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
            opacity=opacity,
            blend_mode=blend_mode,
            compact=compact,
            show_grid=show_grid,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_bins(self, session: Any, bins: list[float]) -> dict[str, Any]:
        return self.invoke(session, "set_bins", {"bins": [float(v) for v in bins]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
