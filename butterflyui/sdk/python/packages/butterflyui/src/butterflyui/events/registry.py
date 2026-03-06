from __future__ import annotations

from dataclasses import dataclass

from ..metadata.common_events import COMMON_EVENT_NAMES

__all__ = ["EventPayloadSpec", "EVENT_PAYLOAD_SPECS", "get_event_payload_spec"]


@dataclass(frozen=True, slots=True)
class EventPayloadSpec:
    name: str
    payload_module: str | None = None


EVENT_PAYLOAD_SPECS: dict[str, EventPayloadSpec] = {
    name: EventPayloadSpec(
        name=name,
        payload_module={
            "open": "overlay",
            "close": "overlay",
            "dismiss": "overlay",
            "click": "pointer",
            "double_click": "pointer",
            "long_press": "pointer",
            "press": "pointer",
            "hover_enter": "pointer",
            "hover_exit": "pointer",
            "hover_move": "pointer",
            "context_menu": "pointer",
            "pan_start": "pointer",
            "pan_update": "pointer",
            "pan_end": "pointer",
            "scale_start": "pointer",
            "scale_update": "pointer",
            "scale_end": "pointer",
            "key_down": "keyboard",
            "key_up": "keyboard",
            "shortcut": "keyboard",
            "change": "input",
            "submit": "input",
            "focus": "input",
            "blur": "input",
        }.get(name),
    )
    for name in COMMON_EVENT_NAMES
}


def get_event_payload_spec(name: str) -> EventPayloadSpec | None:
    return EVENT_PAYLOAD_SPECS.get(str(name))
