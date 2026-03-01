from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MorphingBorder"]

class MorphingBorder(Component):
    """Animated decorative border that transitions between a minimum
    and maximum corner radius while maintaining a coloured outline.

    The Flutter runtime uses an ``AnimatedContainer`` with a
    ``BoxDecoration`` containing both a ``borderRadius`` animation and
    a ``Border.all`` stroke.  The result is a smooth rounded-corner
    transition with a persistent coloured border.

    Example::

        import butterflyui as bui

        border = bui.MorphingBorder(
            bui.Text("Card"),
            min_radius=4,
            max_radius=20,
            color="#60a5fa",
            width=2,
            duration_ms=1000,
        )

    Args:
        min_radius: 
            Corner radius when *animate* is ``False``.  Defaults
            to ``8``.
        max_radius: 
            Corner radius the animation targets.  Defaults to
            ``24``.
        duration_ms: 
            Transition duration in milliseconds.  Defaults to
            ``1200``; clamped to ``1 – 600 000``.
        animate: 
            When ``True`` (default) the radius animates to
            *max_radius*; ``False`` snaps to *min_radius*.
        color: 
            Border stroke colour.  Defaults to ``#60a5fa``.
        width: 
            Border stroke width in logical pixels.  Defaults to
            ``1.5``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "morphing_border"

    def __init__(
        self,
        child: Any | None = None,
        *,
        min_radius: float | None = None,
        max_radius: float | None = None,
        duration_ms: int | None = None,
        animate: bool | None = None,
        color: Any | None = None,
        width: float | None = None,
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
            color=color,
            width=width,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
