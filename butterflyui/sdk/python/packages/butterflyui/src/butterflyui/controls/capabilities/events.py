from __future__ import annotations

__all__ = [
    "INTERACTION_EVENT_NAMES",
    "LIFECYCLE_EVENT_NAMES",
    "VALUE_EVENT_NAMES",
]

INTERACTION_EVENT_NAMES = (
    "click",
    "hover",
    "focus",
    "blur",
    "press",
    "long_press",
    "tap_down",
    "context_menu",
)

VALUE_EVENT_NAMES = (
    "change",
    "submit",
    "select",
    "scroll",
)

LIFECYCLE_EVENT_NAMES = (
    "mount",
    "unmount",
    "open",
    "close",
    "resize",
)
