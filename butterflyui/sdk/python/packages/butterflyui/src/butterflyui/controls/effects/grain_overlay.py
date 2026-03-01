from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GrainOverlay"]

class GrainOverlay(Component):
    """Film-grain noise texture overlay rendered with a ``CustomPainter``.

    The Flutter runtime paints randomly positioned single-pixel
    rectangles over the child using a seeded ``Random`` instance.  The
    dot count is derived from the widget area multiplied by ``density``.
    An optional ``animated`` flag increments the seed each frame for a
    flickering grain effect.

    Example::

        import butterflyui as bui

        grain = bui.GrainOverlay(
            bui.Image(src="photo.png"),
            opacity=0.08,
            density=0.45,
            color="#ffffff",
        )

    Args:
        opacity: 
            Opacity of each grain dot (``0.0`` – ``1.0``).
            Defaults to ``0.08``.
        density: 
            Relative density of grain dots (``0.0`` – ``1.0``).
            Defaults to ``0.45``.
        seed: 
            Integer seed for the pseudo-random number generator.
            Defaults to ``0``.
        color: 
            Colour of the grain dots.  Defaults to white.
        animated: 
            When ``True`` the seed auto-increments to produce
            flickering grain.
        fps: 
            Target frames per second for the animated grain
            refresh.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "grain_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *,
        opacity: float | None = None,
        density: float | None = None,
        seed: int | None = None,
        color: Any | None = None,
        animated: bool | None = None,
        fps: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            opacity=opacity,
            density=density,
            seed=seed,
            color=color,
            animated=animated,
            fps=fps,
            **kwargs,
        )
