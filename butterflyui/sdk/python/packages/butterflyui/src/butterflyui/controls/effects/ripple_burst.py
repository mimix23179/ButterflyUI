from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["RippleBurst"]

@butterfly_control('ripple_burst')
class RippleBurst(EffectControl):
    """
    Expanding concentric ripple rings triggered by tap or
    programmatic ``burst()`` call.

    The Flutter runtime paints *count* concentric circles on a
    ``CustomPaint`` foreground canvas.  An ``AnimationController``
    drives the expansion; each ring is staggered, fading out and
    thinning as it grows toward ``max_radius``.  A ``GestureDetector``
    fires a burst on tap; the ``burst()`` invoke method triggers the
    same animation from Python.

    Example:

    ```python
    import butterflyui as bui

    ripple = bui.RippleBurst(
        bui.Container(width=200, height=200),
        color="#22d3ee",
        count=4,
        duration_ms=600,
        max_radius=120,
    )
    ```
    """

    count: int | None = None
    """
    Number of concentric rings per burst (``1`` – ``8``).
    Defaults to ``3``.
    """

    duration_ms: int | None = None
    """
    Burst animation duration in milliseconds.
    Defaults to ``500``.
    """

    max_radius: float | None = None
    """
    Maximum expansion radius in logical pixels.
    Defaults to ``90``.
    """

    center: Any | None = None
    """
    Reserved — custom ripple origin point.
    """

    def burst(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "burst", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
