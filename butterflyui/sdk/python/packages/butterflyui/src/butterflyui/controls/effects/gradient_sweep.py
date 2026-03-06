from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["GradientSweep"]

@butterfly_control('gradient_sweep')
class GradientSweep(EffectControl):
    """
    Animated sweep-gradient overlay that rotates through configurable
    colours using a ``ShaderMask``.

    The Flutter runtime paints a ``SweepGradient`` via ``ShaderMask``
    (``BlendMode.srcATop``) on top of the child.  An
    ``AnimationController`` continuously advances the rotation angle,
    creating a spinning colour-wheel effect.  Playback can be paused,
    resumed, and the colour list or angle can be updated at runtime
    through invoke methods.

    Example:

    ```python
    import butterflyui as bui

    sweep = bui.GradientSweep(
        bui.Text("Neon"),
        colors=["#22d3ee", "#a78bfa", "#f472b6"],
        duration_ms=2000,
        opacity=0.6,
    )
    ```
    """

    colors: list[Any] | None = None
    """
    List of gradient-stop colours.  Defaults to a built-in
    cyan / purple / pink / green palette if empty.
    """

    stops: list[float] | None = None
    """
    Optional list of gradient stop positions (``0.0`` –
    ``1.0``), one per colour.  Length must match *colors*.
    """

    duration_ms: int | None = None
    """
    Full rotation period in milliseconds.  Defaults
    to ``1800``; clamped to ``1 – 600 000``.
    """

    duration: int | None = None
    """
    Backward-compatible alias for ``*duration_ms*``. When both fields are provided, ``*duration_ms*`` takes precedence and this alias is kept only for compatibility.
    """

    angle: float | None = None
    """
    Static base angle in **degrees** added to the animated
    rotation.
    """

    start_angle: float | None = None
    """
    Sweep gradient start angle in degrees.  Defaults
    to ``0``.
    """

    end_angle: float | None = None
    """
    Sweep gradient end angle in degrees.  Defaults to
    ``360``.
    """

    loop: bool | None = None
    """
    When ``True`` (default) the rotation repeats
    indefinitely.
    """

    autoplay: bool | None = None
    """
    When ``True`` (default) the animation starts on
    mount.
    """

    play: bool | None = None
    """
    Explicit play flag; ``True`` starts, ``False`` pauses.
    """

    playing: bool | None = None
    """
    Backward-compatible alias for ``*play*``. When both fields are provided, ``*play*`` takes precedence and this alias is kept only for compatibility.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `gradient_sweep` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `gradient_sweep` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `gradient_sweep` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `gradient_sweep` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `gradient_sweep` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `gradient_sweep` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `gradient_sweep` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `gradient_sweep` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `gradient_sweep` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `gradient_sweep` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `gradient_sweep` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `gradient_sweep` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `gradient_sweep` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `gradient_sweep` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `gradient_sweep` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `gradient_sweep` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `gradient_sweep` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `gradient_sweep` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `gradient_sweep` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})
