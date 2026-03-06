from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl


__all__ = ["ShimmerShadow"]

@butterfly_control('shimmer_shadow')
class ShimmerShadow(EffectControl):
    """
    Combined shimmer + layered shadow effect wrapper.

    This control applies a shadow stack and then overlays shimmer animation
    around the same child.
    """

    shimmer: Mapping[str, Any] | None = None
    """
    Shimmer animation configuration or strength used by the shadow effect.
    """

    shadow: Mapping[str, Any] | None = None
    """
    Base shadow configuration payload.
    """

    duration_ms: int | None = None
    """
    Duration of the shimmer cycle in milliseconds.
    """

    angle: float | None = None
    """
    Angle value used by the effect, shadow, or shimmer renderer.
    """

    shadows: list[Mapping[str, Any]] | None = None
    """
    Layered shadow definitions applied under the child.
    """

    radius: float | None = None
    """
    Corner radius shared by the shimmer and shadow layers.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `shimmer_shadow` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `shimmer_shadow` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `shimmer_shadow` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `shimmer_shadow` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `shimmer_shadow` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `shimmer_shadow` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `shimmer_shadow` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `shimmer_shadow` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `shimmer_shadow` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `shimmer_shadow` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `shimmer_shadow` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `shimmer_shadow` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `shimmer_shadow` runtime control.
    """
