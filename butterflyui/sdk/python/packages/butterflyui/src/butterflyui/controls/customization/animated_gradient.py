from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["AnimatedGradient"]

@butterfly_control('animated_gradient', field_aliases={'content': 'child'})
class AnimatedGradient(LayoutControl):
    """
    Paints an animated gradient background that continuously transitions its
    colors over time, optionally wrapping a child control.

    The runtime supports linear, radial, and sweep gradient variants. The
    animation controller loops or plays once, with optional ping-pong
    (reverse) behaviour and colour-shift rotation. If fewer than two
    colours are supplied the runtime falls back to a default purple-to-cyan
    pair.

    ```python
    import butterflyui as bui

    bui.AnimatedGradient(
        colors=["#7c3aed", "#06b6d4"],
        duration_ms=2400,
        loop=True,
        ping_pong=True,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    kind: str | None = None
    """
    Backward-compatible alias for ``variant``. When both fields are provided, ``variant`` takes precedence and this alias is kept only for compatibility.
    """

    gradient: str | None = None
    """
    Backward-compatible alias for ``variant``. When both fields are provided, ``variant`` takes precedence and this alias is kept only for compatibility.
    """

    type: str | None = None
    """
    Backward-compatible alias for ``variant``. When both fields are provided, ``variant`` takes precedence and this alias is kept only for compatibility.
    """

    colors: list[Any] | None = None
    """
    List of colour values (hex strings or colour objects). At least two colours are required; the runtime falls back to purple-cyan if fewer are given.
    """

    stops: list[float] | None = None
    """
    Gradient stop positions, each in ``[0.0, 1.0]``. Must match the length of `colors`; ignored if the count differs.
    """

    duration_ms: int | None = None
    """
    Total animation duration in milliseconds. Defaults to ``1800``. Clamped to ``[1, 600000]``.
    """

    duration: int | None = None
    """
    Backward-compatible alias for ``duration_ms``. When both fields are provided, ``duration_ms`` takes precedence and this alias is kept only for compatibility.
    """

    radius: float | None = None
    """
    Corner radius applied to the decorated box that contains the gradient.
    """

    begin: Any | None = None
    """
    Start alignment of a linear gradient (e.g. ``"top_left"`` or ``[x, y]``). Defaults to ``Alignment.topLeft``.
    """

    end: Any | None = None
    """
    End alignment of a linear gradient. Defaults to ``Alignment.bottomRight``.
    """

    angle: float | None = None
    """
    Initial rotation angle in degrees. The animation rotates a full 360° over one cycle starting from this value.
    """

    start_angle: float | None = None
    """
    Start angle for sweep gradients, in degrees. Defaults to ``0``. Also used as the initial rotation angle for linear gradients.
    """

    end_angle: float | None = None
    """
    End angle for sweep gradients, in degrees. Defaults to ``360``.
    """

    loop: bool | None = None
    """
    Controls whether playback restarts automatically after the media reaches the end of the stream.
    """

    autoplay: bool | None = None
    """
    Controls whether playback starts automatically as soon as the media is ready. Leave it disabled when playback should begin only after an explicit user action.
    """

    play: bool | None = None
    """
    Backward-compatible alias for ``playing``. When both fields are provided, ``playing`` takes precedence and this alias is kept only for compatibility.
    """

    playing: bool | None = None
    """
    Controls whether the animation is running. Set ``False`` to pause.
    """

    ping_pong: bool | None = None
    """
    If ``True``, the animation reverses direction at each cycle end instead of snapping back.
    """

    shift: bool | None = None
    """
    If ``True``, the colour list is cyclically rotated as the animation progresses, producing a "rolling" colour effect.
    """

    throttle_ms: int | None = None
    """
    Minimum interval in milliseconds between runtime change events.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `animated_gradient` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `animated_gradient` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `animated_gradient` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `animated_gradient` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `animated_gradient` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `animated_gradient` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `animated_gradient` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `animated_gradient` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `animated_gradient` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `animated_gradient` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `animated_gradient` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `animated_gradient` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `animated_gradient` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `animated_gradient` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `animated_gradient` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `animated_gradient` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `animated_gradient` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `animated_gradient` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `animated_gradient` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})
