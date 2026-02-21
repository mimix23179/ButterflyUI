from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "AnimatedBackground",
    "ParticleField",
    "ScanlineOverlay",
    "Vignette",
]


class AnimatedBackground(Component):
    control_type = "animated_background"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class ParticleField(Component):
    control_type = "particle_field"


class ScanlineOverlay(Component):
    control_type = "scanline_overlay"


class Vignette(Component):
    control_type = "vignette"



