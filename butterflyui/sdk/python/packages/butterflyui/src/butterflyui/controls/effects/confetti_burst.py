from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ConfettiBurst"]

class ConfettiBurst(Component):
    """Animated confetti-particle burst painted on a ``CustomPaint``
    canvas.

    The Flutter runtime uses an ``AnimationController`` to drive
    rectangular confetti pieces that fly outward with random
    trajectories and fade as they fall.  A built-in *Burst* button is
    shown by default; set ``hide_button`` to suppress it and trigger
    bursts programmatically via the ``burst()`` method.

    Example::

        import butterflyui as bui

        confetti = bui.ConfettiBurst(
            colors=["#22d3ee", "#a78bfa", "#f472b6", "#34d399"],
            count=30,
            duration_ms=1200,
            hide_button=True,
        )

    Args:
        colors: 
            List of confetti-piece colours.  
            Defaults to a built-in cyan / purple / pink / green palette.
        count: 
            Number of confetti rectangles per burst (``1`` – ``200``). 
            Defaults to ``18``.
        duration_ms: 
            Burst animation duration in milliseconds. 
            Defaults to ``900``; clamped to ``1 – 600 000``.
        duration: 
            Alias for *duration_ms*.
        gravity: 
            Reserved — gravity multiplier for particle fall speed.
        autoplay: 
            When ``True`` a burst fires automatically on mount.
        loop: 
            When ``True`` the burst replays continuously.
        emit_on_complete: 
            When ``True`` the runtime emits a ``"complete"`` event 
            after each burst finishes.
        hide_button: 
            When ``True`` the default *Burst* toggle button is hidden.
    """
    control_type = "confetti_burst"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        count: int | None = None,
        duration_ms: int | None = None,
        duration: int | None = None,
        gravity: float | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        emit_on_complete: bool | None = None,
        hide_button: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            count=count,
            duration_ms=duration_ms,
            duration=duration,
            gravity=gravity,
            autoplay=autoplay,
            loop=loop,
            emit_on_complete=emit_on_complete,
            hide_button=hide_button,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def burst(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "burst", {})
