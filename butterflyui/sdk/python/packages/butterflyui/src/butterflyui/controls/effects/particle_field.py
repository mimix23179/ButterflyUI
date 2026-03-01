from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ParticleField"]

class ParticleField(Component):
    """Full-featured particle system rendered with a ``CustomPainter``.

    The Flutter runtime spawns *count* particles with randomised
    positions, angles, speeds, sizes, and colours drawn from the
    configured ranges.  An ``AnimationController`` advancing
    continuously drives the painter, which calculates each particle's
    world-space position via simple ballistic motion.  Particles that
    exit the canvas wrap back to the opposite edge when *loop* is
    ``True``.

    Example::

        import butterflyui as bui

        field = bui.ParticleField(
            count=80,
            colors=["#22d3ee", "#a78bfa"],
            min_speed=10,
            max_speed=40,
            opacity=0.5,
            shape="circle",
        )

    Args:
        count: 
            Number of particles (``0`` – ``2000``).  Defaults to
            ``40``.
        colors: 
            List of particle colours.  Falls back to the theme
            accent palette when empty.
        size: 
            Uniform particle diameter; sets both *min_size* and
            *max_size*.
        min_size: 
            Minimum particle diameter in logical pixels.
            Defaults to ``2``.
        max_size: 
            Maximum particle diameter.  Defaults to ``6``.
        speed: 
            Uniform speed; sets both *min_speed* and *max_speed*.
        min_speed: 
            Minimum velocity in logical pixels per second.
            Defaults to ``8``.
        max_speed: 
            Maximum velocity.  Defaults to ``32``.
        direction: 
            Emission direction in **degrees** (0 = right,
            90 = down).  ``None`` emits omnidirectionally.
        spread: 
            Angular spread in degrees around *direction*.
            Defaults to ``30``.
        opacity: 
            Global opacity multiplier (``0.0`` – ``1.0``).
            Defaults to ``0.6``.
        seed: 
            Integer seed for deterministic layout.
        loop: 
            When ``True`` (default) particles wrap at canvas
            edges.
        play: 
            When ``True`` (default) the animation runs.
        shape: 
            ``"circle"`` (default) or ``"square"``.
    """
    control_type = "particle_field"

    def __init__(
        self,
        *,
        count: int | None = None,
        colors: list[Any] | None = None,
        size: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        speed: float | None = None,
        min_speed: float | None = None,
        max_speed: float | None = None,
        direction: float | None = None,
        spread: float | None = None,
        opacity: float | None = None,
        seed: int | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        shape: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            colors=colors,
            size=size,
            min_size=min_size,
            max_size=max_size,
            speed=speed,
            min_speed=min_speed,
            max_speed=max_speed,
            direction=direction,
            spread=spread,
            opacity=opacity,
            seed=seed,
            loop=loop,
            play=play,
            shape=shape,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})
