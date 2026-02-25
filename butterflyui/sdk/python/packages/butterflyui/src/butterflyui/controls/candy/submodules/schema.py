from __future__ import annotations

from ..schema import EVENTS as UMBRELLA_EVENTS
from ..schema import MODULES as UMBRELLA_MODULES

CONTROL_PREFIX = "candy"

MODULE_TOKENS = tuple(str(module) for module in UMBRELLA_MODULES)
MODULE_CANONICAL = MODULE_TOKENS
SUPPORTED_EVENTS = tuple(str(event) for event in UMBRELLA_EVENTS)

MODULE_CLASS_NAMES = {
    "align": "Align",
    "animation": "Animation",
    "aspect_ratio": "AspectRatio",
    "avatar": "Avatar",
    "badge": "Badge",
    "border": "Border",
    "button": "Button",
    "canvas": "Canvas",
    "card": "Card",
    "center": "Center",
    "clip": "Clip",
    "column": "Column",
    "container": "Container",
    "decorated_box": "DecoratedBox",
    "effects": "Effects",
    "fitted_box": "FittedBox",
    "gradient": "Gradient",
    "icon": "Icon",
    "motion": "Motion",
    "outline": "Outline",
    "overflow_box": "OverflowBox",
    "particles": "Particles",
    "row": "Row",
    "shadow": "Shadow",
    "spacer": "Spacer",
    "stack": "Stack",
    "surface": "Surface",
    "text": "Text",
    "transition": "Transition",
    "wrap": "Wrap",
}

CANDY_COMMON_PAYLOAD_KEYS = {
    "enabled",
    "variant",
    "state",
    "slots",
    "leading",
    "trailing",
    "overlay",
    "background",
    "content",
    "animation",
    "transition",
    "motion",
    "events",
    "semantics",
    "accessibility",
    "performance",
}

CANDY_COMMON_PAYLOAD_TYPES = {
    "enabled": "bool",
    "variant": "string",
    "state": "state",
    "slots": "map",
    "leading": "any",
    "trailing": "any",
    "overlay": "any",
    "background": "any",
    "content": "any",
    "animation": "map",
    "transition": "map",
    "motion": "map",
    "events": "events",
    "semantics": "map",
    "accessibility": "map",
    "performance": "map",
}

MODULE_ALLOWED_KEYS = {
    "button": {"label", "text", "icon", "loading", "disabled", "radius", "padding", "bgcolor", "text_color"},
    "card": {"elevation", "radius", "padding", "margin", "bgcolor"},
    "column": {"spacing", "alignment", "main_axis", "cross_axis"},
    "container": {"width", "height", "padding", "margin", "alignment", "bgcolor", "radius"},
    "row": {"spacing", "alignment", "main_axis", "cross_axis"},
    "stack": {"alignment", "fit"},
    "surface": {"bgcolor", "elevation", "radius", "border_color", "border_width"},
    "wrap": {"spacing", "run_spacing", "alignment", "run_alignment"},
    "align": {"alignment", "width_factor", "height_factor"},
    "center": {"width_factor", "height_factor"},
    "spacer": {"width", "height", "flex"},
    "aspect_ratio": {"ratio", "value"},
    "overflow_box": {"alignment", "min_width", "max_width", "min_height", "max_height"},
    "fitted_box": {"fit", "alignment", "clip_behavior"},
    "effects": {"shimmer", "blur", "opacity", "overlay"},
    "particles": {"count", "speed", "size", "gravity", "drift", "overlay", "colors"},
    "border": {"color", "width", "radius", "side", "padding"},
    "shadow": {"color", "blur", "spread", "dx", "dy"},
    "outline": {"outline_color", "outline_width", "radius"},
    "gradient": {"variant", "colors", "stops", "begin", "end", "angle"},
    "animation": {"duration_ms", "curve", "opacity", "scale", "autoplay", "loop", "reverse"},
    "transition": {"duration_ms", "curve", "preset", "key"},
    "canvas": {"width", "height", "commands"},
    "clip": {"shape", "clip_shape", "clip_behavior", "radius"},
    "decorated_box": {"bgcolor", "gradient", "border_color", "border_width", "radius", "shadow"},
    "badge": {"label", "text", "value", "color", "bgcolor", "text_color", "radius"},
    "avatar": {"src", "label", "text", "size", "color", "bgcolor"},
    "icon": {"icon", "size", "color"},
    "text": {"text", "value", "color", "font_size", "size", "font_weight", "weight", "align", "max_lines", "overflow"},
    "motion": {"duration_ms", "curve", "opacity", "scale", "autoplay", "loop", "reverse"},
}

MODULE_PAYLOAD_TYPES = {
    "button": {
        "label": "string",
        "text": "string",
        "icon": "string",
        "loading": "bool",
        "disabled": "bool",
        "radius": "num",
        "padding": "padding",
        "bgcolor": "color",
        "text_color": "color",
    },
    "card": {
        "elevation": "num",
        "radius": "num",
        "padding": "padding",
        "margin": "padding",
        "bgcolor": "color",
    },
    "column": {"spacing": "num", "alignment": "string", "main_axis": "string", "cross_axis": "string"},
    "container": {
        "width": "dimension",
        "height": "dimension",
        "padding": "padding",
        "margin": "padding",
        "alignment": "alignment",
        "bgcolor": "color",
        "radius": "num",
    },
    "row": {"spacing": "num", "alignment": "string", "main_axis": "string", "cross_axis": "string"},
    "stack": {"alignment": "alignment", "fit": "string"},
    "surface": {
        "bgcolor": "color",
        "elevation": "num",
        "radius": "num",
        "border_color": "color",
        "border_width": "num",
    },
    "wrap": {"spacing": "num", "run_spacing": "num", "alignment": "string", "run_alignment": "string"},
    "align": {"alignment": "alignment", "width_factor": "num", "height_factor": "num"},
    "center": {"width_factor": "num", "height_factor": "num"},
    "spacer": {"width": "dimension", "height": "dimension", "flex": "int"},
    "aspect_ratio": {"ratio": "num", "value": "num"},
    "overflow_box": {
        "alignment": "alignment",
        "min_width": "dimension",
        "max_width": "dimension",
        "min_height": "dimension",
        "max_height": "dimension",
    },
    "fitted_box": {"fit": "string", "alignment": "alignment", "clip_behavior": "string"},
    "effects": {"shimmer": "bool", "blur": "num", "opacity": "num", "overlay": "bool"},
    "particles": {"count": "int", "speed": "num", "size": "num", "gravity": "num", "drift": "num", "overlay": "bool", "colors": "list"},
    "border": {"color": "color", "width": "num", "radius": "num", "side": "string", "padding": "padding"},
    "shadow": {"color": "color", "blur": "num", "spread": "num", "dx": "num", "dy": "num"},
    "outline": {"outline_color": "color", "outline_width": "num", "radius": "num"},
    "gradient": {"variant": "string", "colors": "list", "stops": "list", "begin": "any", "end": "any", "angle": "num"},
    "animation": {"duration_ms": "int", "curve": "string", "opacity": "num", "scale": "num", "autoplay": "bool", "loop": "bool", "reverse": "bool"},
    "transition": {"duration_ms": "int", "curve": "string", "preset": "string", "key": "any"},
    "canvas": {"width": "dimension", "height": "dimension", "commands": "list"},
    "clip": {"shape": "string", "clip_shape": "string", "clip_behavior": "string", "radius": "num"},
    "decorated_box": {
        "bgcolor": "color",
        "gradient": "any",
        "border_color": "color",
        "border_width": "num",
        "radius": "num",
        "shadow": "any",
    },
    "badge": {"label": "string", "text": "string", "value": "any", "color": "color", "bgcolor": "color", "text_color": "color", "radius": "num"},
    "avatar": {"src": "string", "label": "string", "text": "string", "size": "num", "color": "color", "bgcolor": "color"},
    "icon": {"icon": "string", "size": "num", "color": "color"},
    "text": {
        "text": "string",
        "value": "string",
        "color": "color",
        "font_size": "num",
        "size": "num",
        "font_weight": "any",
        "weight": "any",
        "align": "string",
        "max_lines": "int",
        "overflow": "string",
    },
    "motion": {"duration_ms": "int", "curve": "string", "opacity": "num", "scale": "num", "autoplay": "bool", "loop": "bool", "reverse": "bool"},
}

_INTERACTIVE_MODULES = {"button", "badge", "avatar", "icon", "text"}
_MOTION_MODULES = {"animation", "motion", "transition"}
_GESTURE_MODULES = {"canvas", "stack", "surface", "container"}

MODULE_EVENTS = {}
for _token in MODULE_TOKENS:
    _events = {"change", "state_change", "module_change"}
    if _token in _INTERACTIVE_MODULES:
        _events.update({"click", "tap", "double_tap", "long_press", "focus", "blur", "focus_change", "hover_enter", "hover_exit"})
    if _token in _MOTION_MODULES:
        _events.update({"animation_start", "animation_end", "transition_start", "transition_end"})
    if _token in _GESTURE_MODULES:
        _events.update({"gesture_pan_start", "gesture_pan_update", "gesture_pan_end", "gesture_scale_start", "gesture_scale_update", "gesture_scale_end"})
    MODULE_EVENTS[_token] = tuple(sorted(_events))

MODULE_ACTIONS = {}
for _token in MODULE_TOKENS:
    _actions = {
        "set_payload",
        "set_props",
        "set_module",
        "set_state",
        "get_state",
        "emit",
        "trigger",
        "activate",
        "emit_change",
        "set_tokens",
        "set_token_overrides",
        "set_theme",
        "set_slots",
        "set_accessibility",
        "register_module",
        "register_foundation",
        "register_interaction",
        "register_motion",
        "register_effect",
        "register_recipe",
        "register_provider",
        "register_command",
    }
    if _token in _INTERACTIVE_MODULES:
        _actions.update({"click", "tap", "focus", "blur"})
    if _token in _MOTION_MODULES:
        _actions.update({"play_motion", "pause_motion"})
    MODULE_ACTIONS[_token] = tuple(sorted(_actions))

__all__ = [
    "CONTROL_PREFIX",
    "MODULE_TOKENS",
    "MODULE_CANONICAL",
    "SUPPORTED_EVENTS",
    "MODULE_CLASS_NAMES",
    "CANDY_COMMON_PAYLOAD_KEYS",
    "CANDY_COMMON_PAYLOAD_TYPES",
    "MODULE_ALLOWED_KEYS",
    "MODULE_PAYLOAD_TYPES",
    "MODULE_EVENTS",
    "MODULE_ACTIONS",
]

