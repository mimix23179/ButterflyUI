from __future__ import annotations

from .actions import ACTION_PROPS, BUTTON_PROPS
from .content import CHILD_PROPS
from .core import CORE_PROPS
from .effects import EFFECT_PROPS
from .events import EVENT_NAMES
from .focus import FOCUS_PROPS
from .input import FORM_FIELD_PROPS, INPUT_PROPS
from .items import ITEMS_PROPS
from .layout import LAYOUT_PROPS
from .motion import MOTION_PROPS
from .overlay import OVERLAY_PROPS
from .scroll import SCROLL_PROPS
from .selection import SELECTION_PROPS, TOGGLE_PROPS
from .surface import SURFACE_PROPS

def slots_for_control(control_type: str) -> tuple[str, ...]:
    return ()


CAPABILITY_PROP_NAMES = {
    "core": CORE_PROPS,
    "layout": LAYOUT_PROPS,
    "surface": SURFACE_PROPS,
    "motion": MOTION_PROPS,
    "effects": EFFECT_PROPS,
    "content": CHILD_PROPS,
    "focus": FOCUS_PROPS,
    "input": INPUT_PROPS,
    "form_field": FORM_FIELD_PROPS,
    "items": ITEMS_PROPS,
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
        for key in ("surface", "motion", "effects")
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
    "ITEMS_PROPS",
    "LAYOUT_PROPS",
    "MOTION_PROPS",
    "OVERLAY_PROPS",
    "PROP_CAPABILITY_OWNERS",
    "SCROLL_PROPS",
    "SELECTION_PROPS",
    "SURFACE_PROPS",
    "TOGGLE_PROPS",
    "VISUAL_CAPABILITY_PROPS",
    "slots_for_control",
]
