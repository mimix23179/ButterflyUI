from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["NoiseDisplacement"]

@butterfly_control('noise_displacement')
class NoiseDisplacement(EffectControl):
    """
    Noise-driven translation jitter that randomly displaces the child
    on one or both axes.

    The Flutter runtime uses an ``AnimationController`` and a seeded
    ``Random`` to compute per-frame translate offsets.  The
    displacement amplitude is governed by ``strength`` and tapers to
    zero when the animation completes (unless looping via ``play`` /
    ``autoplay``).  The ``axis`` parameter restricts motion to
    ``"x"``, ``"y"``, or ``"both"``.

    Example:

    ```python
    import butterflyui as bui

    shake = bui.NoiseDisplacement(
        bui.Text("Shake"),
        strength=4,
        speed=1.5,
        axis="x",
        autoplay=True,
    )
    ```
    """

    strength: float | None = None
    """
    Maximum displacement in logical pixels.  Defaults
    to ``3``.
    """

    speed: float | None = None
    """
    Speed multiplier (``0.1`` – ``6.0``).  Higher values
    shorten the animation duration.  Defaults to ``1``.
    """

    axis: str | None = None
    """
    Displacement axis — ``"x"``, ``"y"``, or ``"both"``
    (default).
    """

    seed: int | None = None
    """
    Integer seed for the pseudo-random offset generator.
    """

    animated: bool | None = None
    """
    When ``True`` the effect plays automatically.
    """

    loop: bool | None = None
    """
    When ``True`` the displacement repeats with reverse.
    """

    play: bool | None = None
    """
    Controls whether the effect or animation should currently be playing.
    """

    autoplay: bool | None = None
    """
    When ``True`` the animation starts on mount.
    """

    duration_ms: int | None = None
    """
    Base animation duration in milliseconds.  Defaults
    to ``350``; actual duration is divided by *speed*.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `noise_displacement` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `noise_displacement` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `noise_displacement` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `noise_displacement` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `noise_displacement` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `noise_displacement` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `noise_displacement` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `noise_displacement` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `noise_displacement` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `noise_displacement` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `noise_displacement` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `noise_displacement` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `noise_displacement` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `noise_displacement` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `noise_displacement` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `noise_displacement` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `noise_displacement` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `noise_displacement` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `noise_displacement` runtime control.
    """

    def trigger(self, session: Any, strength: float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if strength is not None:
            payload["strength"] = float(strength)
        return self.invoke(session, "trigger", payload)

    def set_strength(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_strength", {"value": float(value)})

    def set_speed(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_speed", {"value": float(value)})
