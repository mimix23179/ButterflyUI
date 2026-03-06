from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ConfettiBurst"]

@butterfly_control('confetti_burst')
class ConfettiBurst(EffectControl):
    """
    Animated confetti-particle burst painted on a ``CustomPaint``
    canvas.

    The Flutter runtime uses an ``AnimationController`` to drive
    rectangular confetti pieces that fly outward with random
    trajectories and fade as they fall.  A built-in *Burst* button is
    shown by default; set ``hide_button`` to suppress it and trigger
    bursts programmatically via the ``burst()`` method.

    Example:

    ```python
    import butterflyui as bui

    confetti = bui.ConfettiBurst(
        colors=["#22d3ee", "#a78bfa", "#f472b6", "#34d399"],
        count=30,
        duration_ms=1200,
        hide_button=True,
    )
    ```
    """

    colors: list[Any] | None = None
    """
    List of confetti-piece colours.
    Defaults to a built-in cyan / purple / pink / green palette.
    """

    count: int | None = None
    """
    Number of confetti rectangles per burst (``1`` – ``200``).
    Defaults to ``18``.
    """

    duration_ms: int | None = None
    """
    Burst animation duration in milliseconds.
    Defaults to ``900``; clamped to ``1 – 600 000``.
    """

    duration: int | None = None
    """
    Backward-compatible alias for ``*duration_ms*``. When both fields are provided, ``*duration_ms*`` takes precedence and this alias is kept only for compatibility.
    """

    gravity: float | None = None
    """
    Reserved — gravity multiplier for particle fall speed.
    """

    autoplay: bool | None = None
    """
    When ``True`` a burst fires automatically on mount.
    """

    loop: bool | None = None
    """
    When ``True`` the burst replays continuously.
    """

    emit_on_complete: bool | None = None
    """
    When ``True`` the runtime emits a ``"complete"`` event
    after each burst finishes.
    """

    hide_button: bool | None = None
    """
    When ``True`` the default *Burst* toggle button is hidden.
    """

    def burst(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "burst", {})
