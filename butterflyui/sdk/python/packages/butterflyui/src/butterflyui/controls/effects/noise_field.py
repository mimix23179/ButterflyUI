from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["NoiseField"]

@butterfly_control('noise_field')
class NoiseField(EffectControl):
    """
    Procedural noise-texture field rendered with a ``CustomPainter``.

    The Flutter runtime paints a grid of 2×2-pixel rectangles whose
    alpha is derived from a seeded ``Random`` multiplied by
    ``intensity``.  Wrapping the painter in a
    ``TweenAnimationBuilder`` allows an optional animated transition.
    Tapping the widget increments the seed and emits a ``"tap"`` event.

    Example:

    ```python
    import butterflyui as bui

    noise = bui.NoiseField(
        seed=42,
        intensity=0.35,
        color="#ffffff",
        height=120,
        animated=True,
    )
    ```
    """

    seed: int | None = None
    """
    Integer seed for the ``Random`` generator.  Defaults to
    ``0``.
    """

    intensity: float | None = None
    """
    Per-pixel alpha multiplier (``0.0`` – ``1.0``).
    Defaults to ``0.35``.
    """

    speed: float | None = None
    """
    Reserved — animation speed multiplier.
    """

    kind: str | None = None
    """
    Reserved — noise algorithm variant name.
    """

    animated: bool | None = None
    """
    When ``True`` the painter transitions via a
    ``TweenAnimationBuilder``.
    """
