from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FoldLayer"]

class FoldLayer(Component):
    """Paper-fold stripe-overlay effect that simulates a sheet being
    folded into parallel pleats.

    The Flutter runtime divides the child into a configurable number of
    vertical or horizontal stripes.  Odd-numbered stripes are darkened
    by a semi-transparent black overlay whose alpha scales with
    ``progress``, while the overall widget is slightly scaled down to
    reinforce the 3-D illusion.

    Example::

        import butterflyui as bui

        fold = bui.FoldLayer(
            bui.Image(src="card.png"),
            folds=6,
            progress=0.5,
            axis="vertical",
        )

    Args:
        folds: 
            Number of alternating stripes (``1`` – ``24``). 
            Defaults to ``4``.
        progress: 
            Fold intensity (``0.0`` flat – ``1.0`` fully folded). 
            Controls both stripe darkness and the subtle scale-down.
        axis: 
            ``"vertical"`` (default) for left-right pleats or 
            ``"horizontal"`` for top-bottom pleats.
        perspective: 
            Reserved — perspective depth factor.
        shadow: 
            Maximum shadow alpha on darkened stripes (``0.0`` – ``1.0``). 
            Defaults to ``0.15``.
        enabled: 
            When ``False`` the fold overlay is skipped and 
            the child is rendered unmodified.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "fold_layer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        folds: int | None = None,
        progress: float | None = None,
        axis: str | None = None,
        perspective: float | None = None,
        shadow: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            folds=folds,
            progress=progress,
            axis=axis,
            perspective=perspective,
            shadow=shadow,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_progress(self, session: Any, progress: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"progress": float(progress)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
