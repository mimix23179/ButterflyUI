from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["VisualFx"]


class VisualFx(Component):
    """
    Composite visual-effects pipeline for glow, glass, chromatic shift and sweep.

    The runtime applies enabled effect stages in sequence to a single child.
    Individual stage props can be provided through nested mappings.
    """

    control_type = "visual_fx"

    def __init__(
        self,
        child: Any | None = None,
        *,
        glow: Mapping[str, Any] | None = None,
        glass_blur: Mapping[str, Any] | None = None,
        chromatic_shift: Mapping[str, Any] | None = None,
        gradient_sweep: Mapping[str, Any] | None = None,
        enable_glow: bool | None = None,
        enable_glass_blur: bool | None = None,
        enable_chromatic_shift: bool | None = None,
        enable_gradient_sweep: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            glow=dict(glow) if glow is not None else None,
            glass_blur=dict(glass_blur) if glass_blur is not None else None,
            chromatic_shift=dict(chromatic_shift) if chromatic_shift is not None else None,
            gradient_sweep=dict(gradient_sweep) if gradient_sweep is not None else None,
            enable_glow=enable_glow,
            enable_glass_blur=enable_glass_blur,
            enable_chromatic_shift=enable_chromatic_shift,
            enable_gradient_sweep=enable_gradient_sweep,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

