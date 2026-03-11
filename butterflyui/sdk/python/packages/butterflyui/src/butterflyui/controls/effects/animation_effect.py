from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["AnimationEffect", "Animation"]

@butterfly_control('animation')
class AnimationEffect(EffectControl):
    """
    Low-level Styling animation helper for opacity and transform transitions.
    """

    from_: Mapping[str, Any] | None = None
    """
    Starting state payload for the animation.
    """

    offset: Any | None = None
    """
    Positional offset applied by the animation helper.
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

    scale: float | None = None
    """
    Target scale factor applied by the animation helper.
    """

    rotation: float | None = None
    """
    Rotation in turns or radians, depending on runtime expectations.
    """

    blur: float | None = None
    """
    Blur amount animated by the helper.
    """

Animation = AnimationEffect
