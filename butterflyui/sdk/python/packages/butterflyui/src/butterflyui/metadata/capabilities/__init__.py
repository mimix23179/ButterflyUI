from __future__ import annotations

from ...controls._shared import modifier_capabilities_manifest
from .actions import ACTION_PROPS, BUTTON_PROPS
from .content import CHILD_PROPS
from .core import CORE_PROPS
from .effects import EFFECT_PROPS
from .events import EVENT_NAMES
from .focus import FOCUS_PROPS
from .input import FORM_FIELD_PROPS, INPUT_PROPS
from .layout import LAYOUT_PROPS
from .modifiers import MODIFIER_PROPS
from .motion import MOTION_PROPS
from .overlay import OVERLAY_PROPS
from .scroll import SCROLL_PROPS
from .selection import SELECTION_PROPS, TOGGLE_PROPS
from .style import STYLE_PROPS
from .surface import SURFACE_PROPS

_SHARED_PIPELINE_MANIFEST = modifier_capabilities_manifest()
_SHARED_CONTROL_MANIFEST = _SHARED_PIPELINE_MANIFEST.get("controls", {})


def _manifest_controls(name: str) -> frozenset[str]:
    values = _SHARED_CONTROL_MANIFEST.get(name, ())
    if not isinstance(values, (list, tuple, set, frozenset)):
        return frozenset()
    return frozenset(str(value) for value in values if isinstance(value, str))


def slots_for_control(control_type: str) -> tuple[str, ...]:
    slots_manifest = _SHARED_CONTROL_MANIFEST.get("slots", {})
    if not isinstance(slots_manifest, dict):
        return ()
    ordered: list[str] = []
    seen: set[str] = set()
    for key in ("*", str(control_type)):
        values = slots_manifest.get(key, ())
        if not isinstance(values, (list, tuple, set, frozenset)):
            continue
        for value in values:
            if not isinstance(value, str) or not value or value in seen:
                continue
            ordered.append(value)
            seen.add(value)
    return tuple(ordered)


STYLE_CAPABLE_CONTROLS = _manifest_controls("style")
MODIFIER_CAPABLE_CONTROLS = _manifest_controls("modifiers")
MOTION_CAPABLE_CONTROLS = _manifest_controls("motion")
EFFECT_CAPABLE_CONTROLS = _manifest_controls("effects")

CAPABILITY_PROP_NAMES = {
    "core": CORE_PROPS,
    "layout": LAYOUT_PROPS,
    "surface": SURFACE_PROPS,
    "style": STYLE_PROPS,
    "motion": MOTION_PROPS,
    "modifiers": MODIFIER_PROPS,
    "effects": EFFECT_PROPS,
    "content": CHILD_PROPS,
    "focus": FOCUS_PROPS,
    "input": INPUT_PROPS,
    "form_field": FORM_FIELD_PROPS,
    "selection": SELECTION_PROPS,
    "toggle": TOGGLE_PROPS,
    "scroll": SCROLL_PROPS,
    "overlay": OVERLAY_PROPS,
    "actions": ACTION_PROPS,
    "button": BUTTON_PROPS,
}

PROP_CAPABILITY_OWNERS: dict[str, str] = {}
for _capability_name, _prop_names in CAPABILITY_PROP_NAMES.items():
    for _prop_name in _prop_names:
        PROP_CAPABILITY_OWNERS.setdefault(_prop_name, _capability_name)

ALL_CAPABILITY_PROPS = tuple(
    dict.fromkeys(name for names in CAPABILITY_PROP_NAMES.values() for name in names)
)

VISUAL_CAPABILITY_PROPS = tuple(
    dict.fromkeys(
        name
        for key in ("surface", "style", "motion", "modifiers", "effects")
        for name in CAPABILITY_PROP_NAMES[key]
    )
)

__all__ = [
    "ACTION_PROPS",
    "ALL_CAPABILITY_PROPS",
    "BUTTON_PROPS",
    "CAPABILITY_PROP_NAMES",
    "CHILD_PROPS",
    "CORE_PROPS",
    "EFFECT_PROPS",
    "EVENT_NAMES",
    "FOCUS_PROPS",
    "FORM_FIELD_PROPS",
    "INPUT_PROPS",
    "LAYOUT_PROPS",
    "MODIFIER_PROPS",
    "MODIFIER_CAPABLE_CONTROLS",
    "MOTION_PROPS",
    "MOTION_CAPABLE_CONTROLS",
    "OVERLAY_PROPS",
    "PROP_CAPABILITY_OWNERS",
    "SCROLL_PROPS",
    "SELECTION_PROPS",
    "STYLE_PROPS",
    "STYLE_CAPABLE_CONTROLS",
    "SURFACE_PROPS",
    "TOGGLE_PROPS",
    "VISUAL_CAPABILITY_PROPS",
    "modifier_capabilities_manifest",
    "slots_for_control",
    "EFFECT_CAPABLE_CONTROLS",
]
