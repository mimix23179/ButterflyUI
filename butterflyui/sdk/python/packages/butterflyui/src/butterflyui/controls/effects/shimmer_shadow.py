from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ShimmerShadow"]


class ShimmerShadow(Component):
    """
    Combined shimmer + layered shadow effect wrapper.

    This control applies a shadow stack and then overlays shimmer animation
    around the same child.
    """

    control_type = "shimmer_shadow"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shimmer: Mapping[str, Any] | None = None,
        shadow: Mapping[str, Any] | None = None,
        duration_ms: int | None = None,
        angle: float | None = None,
        opacity: float | None = None,
        shadows: list[Mapping[str, Any]] | None = None,
        radius: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            shimmer=dict(shimmer) if shimmer is not None else None,
            shadow=dict(shadow) if shadow is not None else None,
            duration_ms=duration_ms,
            angle=angle,
            opacity=opacity,
            shadows=[dict(v) for v in shadows] if shadows is not None else None,
            radius=radius,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

