from __future__ import annotations

__all__ = [
    "COMMON_CORE_PROPS",
    "COMMON_LAYOUT_PROPS",
    "COMMON_STYLE_PROPS",
]


COMMON_CORE_PROPS = (
    "id",
    "key",
    "visible",
    "enabled",
    "disabled",
    "interactive",
    "tooltip",
    "cursor",
    "semantics",
    "accessibility",
    "events",
    "data",
)

COMMON_LAYOUT_PROPS = (
    "width",
    "height",
    "min_width",
    "min_height",
    "max_width",
    "max_height",
    "left",
    "top",
    "right",
    "bottom",
    "x",
    "y",
    "z",
    "z_index",
    "padding",
    "margin",
    "alignment",
    "anchor",
    "expand",
    "flex",
    "opacity",
)

COMMON_STYLE_PROPS = (
    "style",
    "style_pack",
    "pack",
    "token_overrides",
    "style_tokens",
    "style_slots",
    "classes",
    "tone",
    "size",
    "density",
    "modifiers",
    "on_hover_modifiers",
    "on_pressed_modifiers",
    "on_focus_modifiers",
    "motion",
    "enter_motion",
    "exit_motion",
    "hover_motion",
    "press_motion",
    "effects",
    "effect_order",
    "effect_clip",
    "effect_target",
    "variant",
)
