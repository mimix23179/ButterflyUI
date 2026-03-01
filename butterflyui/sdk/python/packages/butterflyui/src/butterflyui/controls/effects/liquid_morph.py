from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["LiquidMorph"]

class LiquidMorph(Component):
    """Animated border-radius morph that transitions between a minimum
    and maximum corner radius using ``AnimatedContainer``.

    The Flutter runtime wraps the child in an ``AnimatedContainer``
    with ``Clip.antiAlias`` and a ``BoxDecoration`` whose
    ``borderRadius`` animates between *min_radius* and *max_radius*.
    When ``animate`` is ``False`` the radius snaps to *min_radius*.

    Example::

        import butterflyui as bui

        morph = bui.LiquidMorph(
            bui.Container(width=100, height=100, color="#22d3ee"),
            min_radius=8,
            max_radius=32,
            duration_ms=1500,
        )

    Args:
        min_radius: 
            Corner radius when *animate* is ``False`` or at
            the animation start.  Defaults to ``8``.
        max_radius: 
            Corner radius the animation targets.  Defaults
            to ``24``.
        duration_ms: 
            Transition duration in milliseconds.  Defaults
            to ``1200``; clamped to ``1 – 600 000``.
        animate: 
            When ``True`` (default) the radius animates to
            *max_radius*; when ``False`` it stays at *min_radius*.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "liquid_morph"

    def __init__(
        self,
        child: Any | None = None,
        *,
        min_radius: float | None = None,
        max_radius: float | None = None,
        duration_ms: int | None = None,
        animate: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min_radius=min_radius,
            max_radius=max_radius,
            duration_ms=duration_ms,
            animate=animate,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
