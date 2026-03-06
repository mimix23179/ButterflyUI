from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AnimatedGradient"]

class AnimatedGradient(Component):
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


    variant: str | None = None
    """
    Gradient variant. One of ``"linear"`` (default), ``"radial"``, or ``"sweep"``/``"conic"``.
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

    opacity: float | None = None
    """
    Overall opacity of the gradient surface, ``0.0``–``1.0``.
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

    control_type = "animated_gradient"

    def __init__(
        self,
        *children: Any,
        variant: str | None = None,  
        kind: str | None = None,
        gradient: str | None = None,
        type: str | None = None,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        duration_ms: int | None = None,
        duration: int | None = None,
        radius: float | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        angle: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        opacity: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        ping_pong: bool | None = None,
        shift: bool | None = None,
        throttle_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            kind=kind,
            gradient=gradient,
            type=type,
            colors=colors,
            stops=stops,
            duration_ms=duration_ms,
            duration=duration,
            radius=radius,
            begin=begin,
            end=end,
            angle=angle,
            start_angle=start_angle,
            end_angle=end_angle,
            opacity=opacity,
            loop=loop,
            autoplay=autoplay,
            play=play,
            playing=playing,
            ping_pong=ping_pong,
            shift=shift,
            throttle_ms=throttle_ms,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

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
