from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["MorphingBorder"]

@butterfly_control('morphing_border')
class MorphingBorder(EffectControl):
    """
    Animated decorative border that transitions between a minimum
    and maximum corner radius while maintaining a coloured outline.

    The Flutter runtime uses an ``AnimatedContainer`` with a
    ``BoxDecoration`` containing both a ``borderRadius`` animation and
    a ``Border.all`` stroke.  The result is a smooth rounded-corner
    transition with a persistent coloured border.

    Example:

    ```python
    import butterflyui as bui

    border = bui.MorphingBorder(
        bui.Text("Card"),
        min_radius=4,
        max_radius=20,
        color="#60a5fa",
        width=2,
        duration_ms=1000,
    )
    ```
    """

    min_radius: float | None = None
    """
    Corner radius when *animate* is ``False``.  Defaults
    to ``8``.
    """

    max_radius: float | None = None
    """
    Corner radius the animation targets.  Defaults to
    ``24``.
    """

    duration_ms: int | None = None
    """
    Transition duration in milliseconds.  Defaults to
    ``1200``; clamped to ``1 – 600 000``.
    """

    animate: bool | None = None
    """
    When ``True`` (default) the radius animates to
    *max_radius*; ``False`` snaps to *min_radius*.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
