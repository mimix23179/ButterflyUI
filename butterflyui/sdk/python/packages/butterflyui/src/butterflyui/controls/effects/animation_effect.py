from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl


__all__ = ["AnimationEffect", "Animation"]

@butterfly_control('animation')
class AnimationEffect(EffectControl):
    """
    Low-level timeline animation wrapper for opacity and transform transitions.
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

    foreground: Any | None = None
    """
    Foreground value forwarded to the `animation` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `animation` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `animation` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `animation` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `animation` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `animation` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `animation` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `animation` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `animation` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `animation` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `animation` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `animation` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `animation` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `animation` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `animation` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `animation` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `animation` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `animation` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `animation` runtime control.
    """

Animation = AnimationEffect
