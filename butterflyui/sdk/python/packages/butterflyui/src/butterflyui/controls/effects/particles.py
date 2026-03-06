from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Particles"]

class Particles(Component):
    """
    Convenience alias that delegates to ``ParticleField`` at runtime.
    
    The Flutter runtime maps ``density`` to ``count`` when present and
    passes all properties through to ``buildParticleFieldControl``.
    See ``ParticleField`` for the full description of the particle
    system.
    
    Example:
    
    ```python
    import butterflyui as bui

    fx = bui.Particles(
        count=60,
        colors=["#22d3ee", "#a78bfa"],
        speed=20,
        opacity=0.5,
    )
    ```
    """


    count: int | None = None
    """
    Number of particles to spawn (``0`` – ``2000``).
    Defaults to ``40``.
    """

    colors: list[Any] | None = None
    """
    List of particle colours.  Falls back to the theme
    accent palette when empty.
    """

    min_size: float | None = None
    """
    Minimum particle diameter in logical pixels.
    Defaults to ``2``.
    """

    max_size: float | None = None
    """
    Maximum particle diameter.  Defaults to ``6``.
    """

    speed: float | None = None
    """
    Uniform particle speed; overrides both *min_speed*
    and *max_speed*.
    """

    min_speed: float | None = None
    """
    Minimum particle velocity in pixels per second.
    Defaults to ``8``.
    """

    max_speed: float | None = None
    """
    Maximum particle velocity.  Defaults to ``32``.
    """

    direction: float | None = None
    """
    Emission direction in **degrees** (0 = right,
    90 = down).  ``None`` emits omnidirectionally.
    """

    spread: float | None = None
    """
    Angular spread in degrees around *direction*.
    Defaults to ``30``.
    """

    opacity: float | None = None
    """
    Global particle opacity (``0.0`` – ``1.0``).
    Defaults to ``0.6``.
    """

    seed: int | None = None
    """
    Integer seed for deterministic particle layout.
    """

    loop: bool | None = None
    """
    When ``True`` (default) particles wrap around the
    canvas edges.
    """

    play: bool | None = None
    """
    When ``True`` (default) the animation runs; ``False``
    pauses.
    """

    shape: str | None = None
    """
    Particle shape — ``"circle"`` (default) or
    ``"square"``.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "particles"

    def __init__(
        self,
        *,
        count: int | None = None,
        colors: list[Any] | None = None,
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
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            colors=colors,
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
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
