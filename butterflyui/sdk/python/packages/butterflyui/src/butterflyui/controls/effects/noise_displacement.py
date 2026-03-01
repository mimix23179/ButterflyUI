from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from ._eventful_effect import _EventfulEffect

__all__ = ["NoiseDisplacement"]

class NoiseDisplacement(_EventfulEffect):
    """Noise-driven translation jitter that randomly displaces the child
    on one or both axes.

    The Flutter runtime uses an ``AnimationController`` and a seeded
    ``Random`` to compute per-frame translate offsets.  The
    displacement amplitude is governed by ``strength`` and tapers to
    zero when the animation completes (unless looping via ``play`` /
    ``autoplay``).  The ``axis`` parameter restricts motion to
    ``"x"``, ``"y"``, or ``"both"``.

    Example::

        import butterflyui as bui

        shake = bui.NoiseDisplacement(
            bui.Text("Shake"),
            strength=4,
            speed=1.5,
            axis="x",
            autoplay=True,
        )

    Args:
        strength: 
            Maximum displacement in logical pixels.  Defaults
            to ``3``.
        speed: 
            Speed multiplier (``0.1`` – ``6.0``).  Higher values
            shorten the animation duration.  Defaults to ``1``.
        axis: 
            Displacement axis — ``"x"``, ``"y"``, or ``"both"``
            (default).
        seed: 
            Integer seed for the pseudo-random offset generator.
        animated: 
            When ``True`` the effect plays automatically.
        loop: 
            When ``True`` the displacement repeats with reverse.
        play: 
            Explicit play toggle.
        autoplay: 
            When ``True`` the animation starts on mount.
        duration_ms: 
            Base animation duration in milliseconds.  Defaults
            to ``350``; actual duration is divided by *speed*.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "noise_displacement"

    def __init__(
        self,
        child: Any | None = None,
        *,
        strength: float | None = None,
        speed: float | None = None,
        axis: str | None = None,
        seed: int | None = None,
        animated: bool | None = None,
        loop: bool | None = None,
        play: bool | None = None,
        autoplay: bool | None = None,
        duration_ms: int | None = None,
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
            strength=strength,
            speed=speed,
            axis=axis,
            seed=seed,
            animated=animated,
            loop=loop,
            play=play,
            autoplay=autoplay,
            duration_ms=duration_ms,
            **kwargs,
        )

    def trigger(self, session: Any, strength: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if strength is not None:
            payload["strength"] = float(strength)
        return self.invoke(session, "trigger", payload)

    def set_strength(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_strength", {"value": float(value)})

    def set_speed(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_speed", {"value": float(value)})
