from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["FoldLayer"]

@butterfly_control('fold_layer')
class FoldLayer(EffectControl):
    """
    Paper-fold stripe-overlay effect that simulates a sheet being
    folded into parallel pleats.

    The Flutter runtime divides the child into a configurable number of
    vertical or horizontal stripes.  Odd-numbered stripes are darkened
    by a semi-transparent black overlay whose alpha scales with
    ``progress``, while the overall widget is slightly scaled down to
    reinforce the 3-D illusion.

    Example:

    ```python
    import butterflyui as bui

    fold = bui.FoldLayer(
        bui.Image(src="card.png"),
        folds=6,
        progress=0.5,
        axis="vertical",
    )
    ```
    """

    folds: int | None = None
    """
    Number of alternating stripes (``1`` – ``24``).
    Defaults to ``4``.
    """

    progress: float | None = None
    """
    Fold intensity (``0.0`` flat – ``1.0`` fully folded).
    Controls both stripe darkness and the subtle scale-down.
    """

    axis: str | None = None
    """
    ``"vertical"`` (default) for left-right pleats or
    ``"horizontal"`` for top-bottom pleats.
    """

    perspective: float | None = None
    """
    Reserved — perspective depth factor.
    """

    def set_progress(self, session: Any, progress: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"progress": float(progress)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
