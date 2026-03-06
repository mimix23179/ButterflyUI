from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ParticleField"]

@butterfly_control('particle_field')
class ParticleField(EffectControl):
    """
    Full-featured particle system rendered with a ``CustomPainter``.

    The Flutter runtime spawns *count* particles with randomised
    positions, angles, speeds, sizes, and colours drawn from the
    configured ranges.  An ``AnimationController`` advancing
    continuously drives the painter, which calculates each particle's
    world-space position via simple ballistic motion.  Particles that
    exit the canvas wrap back to the opposite edge when *loop* is
    ``True``.

    Example:

    ```python
    import butterflyui as bui

    field = bui.ParticleField(
        count=80,
        colors=["#22d3ee", "#a78bfa"],
        min_speed=10,
        max_speed=40,
        opacity=0.5,
        shape="circle",
    )
    ```
    """

    count: int | None = None
    """
    Number of particles (``0`` – ``2000``).  Defaults to
    ``40``.
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
    Uniform speed; sets both *min_speed* and *max_speed*.
    """

    min_speed: float | None = None
    """
    Minimum velocity in logical pixels per second.
    Defaults to ``8``.
    """

    max_speed: float | None = None
    """
    Maximum velocity.  Defaults to ``32``.
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
    Integer seed for deterministic layout.
    """

    loop: bool | None = None
    """
    When ``True`` (default) particles wrap at canvas
    edges.
    """

    play: bool | None = None
    """
    When ``True`` (default) the animation runs.
    """

    shape: str | None = None
    """
    ``"circle"`` (default) or ``"square"``.
    """

    gravity: Any | None = None
    """
    Gravity value forwarded to the `particle_field` runtime control.
    """

    drift: Any | None = None
    """
    Drift value forwarded to the `particle_field` runtime control.
    """

    link_distance: Any | None = None
    """
    Link distance value forwarded to the `particle_field` runtime control.
    """

    line_color: Any | None = None
    """
    Line color value forwarded to the `particle_field` runtime control.
    """

    line_opacity: Any | None = None
    """
    Line opacity value forwarded to the `particle_field` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `particle_field` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `particle_field` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `particle_field` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `particle_field` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `particle_field` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `particle_field` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `particle_field` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `particle_field` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `particle_field` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `particle_field` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `particle_field` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `particle_field` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `particle_field` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `particle_field` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `particle_field` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `particle_field` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `particle_field` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `particle_field` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `particle_field` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_seed(self, session: Any, seed: int) -> dict[str, Any]:
        return self.invoke(session, "set_seed", {"seed": int(seed)})
