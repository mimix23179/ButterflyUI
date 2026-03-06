from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Particles"]

@butterfly_control('particles')
class Particles(EffectControl):
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `particles` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `particles` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `particles` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `particles` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `particles` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `particles` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `particles` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `particles` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `particles` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `particles` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `particles` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `particles` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `particles` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `particles` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `particles` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `particles` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `particles` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `particles` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `particles` runtime control.
    """
