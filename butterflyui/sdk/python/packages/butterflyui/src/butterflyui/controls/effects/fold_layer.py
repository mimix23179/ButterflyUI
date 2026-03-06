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

    shadow: float | None = None
    """
    Maximum shadow alpha on darkened stripes (``0.0`` – ``1.0``).
    Defaults to ``0.15``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `fold_layer` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `fold_layer` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `fold_layer` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `fold_layer` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `fold_layer` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `fold_layer` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `fold_layer` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `fold_layer` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `fold_layer` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `fold_layer` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `fold_layer` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `fold_layer` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `fold_layer` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `fold_layer` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `fold_layer` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `fold_layer` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `fold_layer` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `fold_layer` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `fold_layer` runtime control.
    """

    def set_progress(self, session: Any, progress: float) -> dict[str, Any]:
        return self.invoke(session, "set_progress", {"progress": float(progress)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
