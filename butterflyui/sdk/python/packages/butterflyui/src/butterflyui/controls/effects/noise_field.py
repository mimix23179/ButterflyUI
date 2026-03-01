from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NoiseField"]

class NoiseField(Component):
    """Procedural noise-texture field rendered with a ``CustomPainter``.

    The Flutter runtime paints a grid of 2×2-pixel rectangles whose
    alpha is derived from a seeded ``Random`` multiplied by
    ``intensity``.  Wrapping the painter in a
    ``TweenAnimationBuilder`` allows an optional animated transition.
    Tapping the widget increments the seed and emits a ``"tap"`` event.

    Example::

        import butterflyui as bui

        noise = bui.NoiseField(
            seed=42,
            intensity=0.35,
            color="#ffffff",
            height=120,
            animated=True,
        )

    Args:
        seed: 
            Integer seed for the ``Random`` generator.  Defaults to
            ``0``.
        intensity: 
            Per-pixel alpha multiplier (``0.0`` – ``1.0``).
            Defaults to ``0.35``.
        speed: 
            Reserved — animation speed multiplier.
        color: 
            Pixel colour.  Defaults to white.
        kind: 
            Reserved — noise algorithm variant name.
        height: 
            Explicit height of the ``SizedBox`` containing the
            canvas.  Defaults to ``100`` logical pixels.
        animated: 
            When ``True`` the painter transitions via a
            ``TweenAnimationBuilder``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "noise_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        seed: int | None = None,
        intensity: float | None = None,
        speed: float | None = None,
        color: Any | None = None,
        kind: str | None = None,
        height: float | None = None,
        animated: bool | None = None,
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
            seed=seed,
            intensity=intensity,
            speed=speed,
            color=color,
            kind=kind,
            height=height,
            animated=animated,
            **kwargs,
        )
