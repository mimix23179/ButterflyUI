from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GradientSweep"]

class GradientSweep(Component):
    """Animated sweep-gradient overlay that rotates through configurable
    colours using a ``ShaderMask``.

    The Flutter runtime paints a ``SweepGradient`` via ``ShaderMask``
    (``BlendMode.srcATop``) on top of the child.  An
    ``AnimationController`` continuously advances the rotation angle,
    creating a spinning colour-wheel effect.  Playback can be paused,
    resumed, and the colour list or angle can be updated at runtime
    through invoke methods.

    Example::

        import butterflyui as bui

        sweep = bui.GradientSweep(
            bui.Text("Neon"),
            colors=["#22d3ee", "#a78bfa", "#f472b6"],
            duration_ms=2000,
            opacity=0.6,
        )

    Args:
        colors: 
            List of gradient-stop colours.  Defaults to a built-in
            cyan / purple / pink / green palette if empty.
        stops: 
            Optional list of gradient stop positions (``0.0`` –
            ``1.0``), one per colour.  Length must match *colors*.
        duration_ms: 
            Full rotation period in milliseconds.  Defaults
            to ``1800``; clamped to ``1 – 600 000``.
        duration: 
            Alias for *duration_ms*.
        angle: 
            Static base angle in **degrees** added to the animated
            rotation.
        start_angle: 
            Sweep gradient start angle in degrees.  Defaults
            to ``0``.
        end_angle: 
            Sweep gradient end angle in degrees.  Defaults to
            ``360``.
        opacity: 
            Shader mask opacity (``0.0`` – ``1.0``).  Defaults to
            ``0.6``.
        loop: 
            When ``True`` (default) the rotation repeats
            indefinitely.
        autoplay: 
            When ``True`` (default) the animation starts on
            mount.
        play: 
            Explicit play flag; ``True`` starts, ``False`` pauses.
        playing: 
            Alias for *play*.
    """
    control_type = "gradient_sweep"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        duration_ms: int | None = None,
        duration: int | None = None,
        angle: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        opacity: float | None = None,
        loop: bool | None = None,
        autoplay: bool | None = None,
        play: bool | None = None,
        playing: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            stops=stops,
            duration_ms=duration_ms,
            duration=duration,
            angle=angle,
            start_angle=start_angle,
            end_angle=end_angle,
            opacity=opacity,
            loop=loop,
            autoplay=autoplay,
            play=play,
            playing=playing,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

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
