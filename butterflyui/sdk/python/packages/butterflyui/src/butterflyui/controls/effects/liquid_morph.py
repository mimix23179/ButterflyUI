from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["LiquidMorph"]

@butterfly_control('liquid_morph')
class LiquidMorph(EffectControl):
    """
    Animated border-radius morph that transitions between a minimum
    and maximum corner radius using ``AnimatedContainer``.

    The Flutter runtime wraps the child in an ``AnimatedContainer``
    with ``Clip.antiAlias`` and a ``BoxDecoration`` whose
    ``borderRadius`` animates between *min_radius* and *max_radius*.
    When ``animate`` is ``False`` the radius snaps to *min_radius*.

    Example:

    ```python
    import butterflyui as bui

    morph = bui.LiquidMorph(
        bui.Container(width=100, height=100, color="#22d3ee"),
        min_radius=8,
        max_radius=32,
        duration_ms=1500,
    )
    ```
    """

    min_radius: float | None = None
    """
    Corner radius when *animate* is ``False`` or at
    the animation start.  Defaults to ``8``.
    """

    max_radius: float | None = None
    """
    Corner radius the animation targets.  Defaults
    to ``24``.
    """

    duration_ms: int | None = None
    """
    Transition duration in milliseconds.  Defaults
    to ``1200``; clamped to ``1 – 600 000``.
    """

    animate: bool | None = None
    """
    When ``True`` (default) the radius animates to
    *max_radius*; when ``False`` it stays at *min_radius*.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
