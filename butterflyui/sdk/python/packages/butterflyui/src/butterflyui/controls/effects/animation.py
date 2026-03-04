from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Animation"]


class Animation(Component):
    """
    Low-level timeline animation wrapper for opacity/transform/blur/shadow transitions.

    ``Animation`` is intended as the reusable interpolation engine under higher-level
    interaction choreography. It accepts either:
    - direct scalar props (``opacity``, ``scale``, ``offset``, ``rotation``), or
    - structured ``from`` / ``to`` maps, or
    - ``keyframes`` for piecewise interpolation.

    The runtime resolves all inputs into a progress timeline ``t = 0..1`` and
    applies transforms to the child in a stable order: translate -> rotate ->
    scale -> blur/shadow -> opacity.

    Example:
        ```python
        import butterflyui as bui

        anim = bui.Animation(
            bui.Text("Hello"),
            duration="medium",
            curve="emphasized",
            from_={"opacity": 0.0, "y": 14, "scale": 0.96},
            to={"opacity": 1.0, "y": 0, "scale": 1.0},
        )
        ```

    Args:
        child:
            Primary child control to animate.
        children:
            Additional children; the runtime uses the first renderable child.
        duration:
            Named duration token: ``"short"``, ``"medium"``, ``"long"``.
        duration_ms:
            Explicit duration in milliseconds. Overrides ``duration``.
        delay_ms:
            Optional animation delay before playback begins.
        curve:
            Easing curve name (for example ``linear``, ``ease_out``,
            ``ease_in_out``, ``emphasized``, ``spring``).
        enabled:
            When ``False``, bypasses all animation and renders child directly.
        play:
            If ``False``, progress remains at ``0`` (or ``1`` if ``reverse`` is set).
        reverse:
            Reverses animation direction.
        repeat:
            Repeats the animation loop while mounted.
        mirror:
            If ``True`` with ``repeat=True``, alternates forward/reverse cycles.
        from_:
            Map of starting values. Common keys:
            ``opacity``, ``scale``, ``x``, ``y``, ``offset``, ``rotation``,
            ``blur``, ``shadow_blur``, ``shadow_spread``, ``glow_blur``,
            ``glow_spread``, ``glow_opacity``, ``color``.
        to:
            Map of target values. Same key set as ``from_``.
        keyframes:
            List of keyframes ``{"t": 0.0..1.0, "props": {...}}`` for piecewise
            interpolation of numeric/color values.
        opacity:
            Shorthand target opacity (0..1).
        scale:
            Shorthand target scale.
        offset:
            Shorthand target translation offset ``[x, y]`` or ``{"x":..., "y":...}``.
        rotation:
            Shorthand target rotation in degrees.
        blur:
            Shorthand target blur sigma.
        shadow:
            Optional box-shadow descriptor merged into effect interpolation.
        color:
            Optional target tint color.
        events:
            Runtime event subscriptions for animation lifecycle hooks.
        props:
            Raw prop overrides merged after typed args.
        style:
            Style map forwarded to renderer style pipeline.
        strict:
            Enables strict validation when supported.
    """

    control_type = "animation"

    def __init__(
        self,
        child: Any | None = None,
        *children_args: Any,
        duration: str | None = None,
        duration_ms: int | None = None,
        delay_ms: int | None = None,
        curve: str | None = None,
        enabled: bool | None = None,
        play: bool | None = None,
        reverse: bool | None = None,
        repeat: bool | None = None,
        mirror: bool | None = None,
        from_: Mapping[str, Any] | None = None,
        to: Mapping[str, Any] | None = None,
        keyframes: list[Mapping[str, Any]] | None = None,
        opacity: float | None = None,
        scale: float | None = None,
        offset: Any | None = None,
        rotation: float | None = None,
        blur: float | None = None,
        shadow: Any | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            duration=duration,
            duration_ms=duration_ms,
            delay_ms=delay_ms,
            curve=curve,
            enabled=enabled,
            play=play,
            reverse=reverse,
            repeat=repeat,
            mirror=mirror,
            **({"from": dict(from_)} if from_ is not None else {}),
            to=dict(to) if to is not None else None,
            keyframes=[dict(frame) for frame in keyframes] if keyframes else None,
            opacity=opacity,
            scale=scale,
            offset=offset,
            rotation=rotation,
            blur=blur,
            shadow=shadow,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(
            *children_args,
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )
