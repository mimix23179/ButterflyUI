from __future__ import annotations

from .animation import AnimationSpec
from .control import Component, Control
from .performance import PerformanceConfig, enable_60fps, performance_config
from .presets import COMFY_STYLE, GLASS_STYLE, RETRO_STYLE, SCIFI_STYLE, TERMINAL_STYLE
from .responsive import Breakpoints
from .schema import (
    CONTROL_SCHEMAS,
    FRAME_CHILD_SCHEMA,
    ValidationError,
    ensure_valid_frame_child,
    ensure_valid_props,
    normalize_alignment,
    normalize_color_matrix,
    normalize_dimension,
    normalize_frame,
    normalize_offset,
    normalize_padding,
    normalize_scale,
    normalize_skew,
    validate_frame_child,
    validate_props,
)
from .style import (
    BoxShadow,
    DecorationImage,
    LinearGradient,
    RadialGradient,
    Style,
    SweepGradient,
)

__all__ = [
    "AnimationSpec",
    "Component",
    "Control",
    "PerformanceConfig",
    "performance_config",
    "enable_60fps",
    "Breakpoints",
    "CONTROL_SCHEMAS",
    "FRAME_CHILD_SCHEMA",
    "ValidationError",
    "validate_props",
    "validate_frame_child",
    "ensure_valid_props",
    "ensure_valid_frame_child",
    "normalize_alignment",
    "normalize_color_matrix",
    "normalize_dimension",
    "normalize_frame",
    "normalize_offset",
    "normalize_padding",
    "normalize_scale",
    "normalize_skew",
    "Style",
    "BoxShadow",
    "LinearGradient",
    "RadialGradient",
    "SweepGradient",
    "DecorationImage",
    "TERMINAL_STYLE",
    "SCIFI_STYLE",
    "RETRO_STYLE",
    "COMFY_STYLE",
    "GLASS_STYLE",
]
