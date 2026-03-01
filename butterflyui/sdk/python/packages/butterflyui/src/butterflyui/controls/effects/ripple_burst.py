from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RippleBurst"]

class RippleBurst(Component):
    """Expanding concentric ripple rings triggered by tap or
    programmatic ``burst()`` call.

    The Flutter runtime paints *count* concentric circles on a
    ``CustomPaint`` foreground canvas.  An ``AnimationController``
    drives the expansion; each ring is staggered, fading out and
    thinning as it grows toward ``max_radius``.  A ``GestureDetector``
    fires a burst on tap; the ``burst()`` invoke method triggers the
    same animation from Python.

    Example::

        import butterflyui as bui

        ripple = bui.RippleBurst(
            bui.Container(width=200, height=200),
            color="#22d3ee",
            count=4,
            duration_ms=600,
            max_radius=120,
        )

    Args:
        color: 
            Ripple ring colour.  Defaults to the primary colour
            from the current theme.
        count: 
            Number of concentric rings per burst (``1`` – ``8``).
            Defaults to ``3``.
        duration_ms: 
            Burst animation duration in milliseconds.
            Defaults to ``500``.
        max_radius: 
            Maximum expansion radius in logical pixels.
            Defaults to ``90``.
        center: 
            Reserved — custom ripple origin point.
    """
    control_type = "ripple_burst"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        count: int | None = None,
        duration_ms: int | None = None,
        max_radius: float | None = None,
        center: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            count=count,
            duration_ms=duration_ms,
            max_radius=max_radius,
            center=center,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def burst(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "burst", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
