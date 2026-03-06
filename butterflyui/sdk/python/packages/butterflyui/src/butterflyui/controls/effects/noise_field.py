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

    color: Any | None = None
    """
    Pixel colour.  Defaults to white.
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

    foreground: Any | None = None
    """
    Foreground value forwarded to the `noise_field` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `noise_field` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `noise_field` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `noise_field` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `noise_field` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `noise_field` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `noise_field` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `noise_field` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `noise_field` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `noise_field` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `noise_field` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `noise_field` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `noise_field` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `noise_field` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `noise_field` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `noise_field` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `noise_field` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `noise_field` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `noise_field` runtime control.
    """
