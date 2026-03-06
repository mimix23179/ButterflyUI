from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["AnimationEffect", "Animation"]


class AnimationEffect(Component):
    """
    Low-level timeline animation wrapper for opacity and transform transitions.

    Args:
        child:
            Primary child control wrapped by the animation.
        duration:
            Named duration token or runtime duration string.
        duration_ms:
            Duration of the animation in milliseconds.
        delay_ms:
            Delay before the animation starts, in milliseconds.
        curve:
            Animation curve name used by the runtime.
        enabled:
            Whether the animation wrapper is active.
        play:
            Whether the animation should play immediately.
        reverse:
            Whether the animation should run in reverse.
        repeat:
            Whether the animation should loop continuously.
        mirror:
            Whether repeated animation cycles should alternate direction.
        from_:
            Starting state payload for the animation.
        to:
            Ending state payload for the animation.
        keyframes:
            Intermediate keyframe list for more complex animations.
        opacity:
            Target opacity applied by the wrapper.
        scale:
            Target scale factor applied by the wrapper.
        offset:
            Positional offset applied by the wrapper.
        rotation:
            Rotation in turns or radians, depending on runtime expectations.
        blur:
            Blur amount animated by the wrapper.
        shadow:
            Shadow payload animated by the wrapper.
        color:
            Tint or overlay color animated by the wrapper.
        events:
            Runtime events emitted by the animation wrapper.
    """


    from_: Mapping[str, Any] | None = None
    """
    Starting state payload for the animation.
    """

    offset: Any | None = None
    """
    Positional offset applied by the wrapper.
    """


    duration: str | None = None
    """
    Named duration token or runtime duration string.
    """

    duration_ms: int | None = None
    """
    Duration of the animation in milliseconds.
    """

    delay_ms: int | None = None
    """
    Delay before the animation starts, in milliseconds.
    """

    curve: str | None = None
    """
    Animation curve name used by the runtime.
    """

    play: bool | None = None
    """
    Whether the animation should play immediately.
    """

    reverse: bool | None = None
    """
    Whether the animation should run in reverse.
    """

    repeat: bool | None = None
    """
    Whether the animation should loop continuously.
    """

    mirror: bool | None = None
    """
    Whether repeated animation cycles should alternate direction.
    """

    to: Mapping[str, Any] | None = None
    """
    Ending state payload for the animation.
    """

    keyframes: list[Mapping[str, Any]] | None = None
    """
    Intermediate keyframe list for more complex animations.
    """

    opacity: float | None = None
    """
    Target opacity applied by the wrapper.
    """

    scale: float | None = None
    """
    Target scale factor applied by the wrapper.
    """

    rotation: float | None = None
    """
    Rotation in turns or radians, depending on runtime expectations.
    """

    blur: float | None = None
    """
    Blur amount animated by the wrapper.
    """

    shadow: Any | None = None
    """
    Shadow payload animated by the wrapper.
    """

    color: Any | None = None
    """
    Tint or overlay color animated by the wrapper.
    """

    events: list[str] | None = None
    """
    Runtime events emitted by the animation wrapper.
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


Animation = AnimationEffect
