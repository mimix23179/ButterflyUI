from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["AnimationEffect", "Animation"]


class AnimationEffect(Component):
    """Low-level timeline animation wrapper for opacity/transform transitions."""

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
