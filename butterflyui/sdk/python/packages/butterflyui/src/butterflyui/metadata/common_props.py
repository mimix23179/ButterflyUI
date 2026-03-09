from __future__ import annotations

from .capabilities import (
    CORE_PROPS,
    EFFECT_PROPS,
    LAYOUT_PROPS,
    MOTION_PROPS,
    SURFACE_PROPS,
)

__all__ = [
    "COMMON_CORE_PROPS",
    "COMMON_LAYOUT_PROPS",
    "COMMON_STYLE_PROPS",
]


COMMON_CORE_PROPS = CORE_PROPS

COMMON_LAYOUT_PROPS = LAYOUT_PROPS

COMMON_STYLE_PROPS = tuple(
    dict.fromkeys(
        (*SURFACE_PROPS, *MOTION_PROPS, *EFFECT_PROPS)
    )
)
