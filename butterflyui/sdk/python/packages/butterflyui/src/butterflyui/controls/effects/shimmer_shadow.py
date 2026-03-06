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
