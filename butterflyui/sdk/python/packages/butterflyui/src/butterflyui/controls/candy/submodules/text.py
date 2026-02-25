from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CandySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "text"


class Text(CandySubmodule):
    """Candy submodule host control for `text`."""

    control_type = "candy_text"
    umbrella = "candy"
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN

    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))
    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))
    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))
    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))

    def __init__(
        self,
        *children: object,
        payload: Mapping[str, object] | None = None,
        props: Mapping[str, object] | None = None,
        style: Mapping[str, object] | None = None,
        strict: bool = False,
        align: str | None = None,
        color: str | int | None = None,
        font_size: int | float | None = None,
        font_weight: object | None = None,
        max_lines: int | None = None,
        overflow: str | None = None,
        size: int | float | None = None,
        text: str | None = None,
        value: str | None = None,
        weight: object | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if align is not None:
            resolved_payload["align"] = align
        if color is not None:
            resolved_payload["color"] = color
        if font_size is not None:
            resolved_payload["font_size"] = font_size
        if font_weight is not None:
            resolved_payload["font_weight"] = font_weight
        if max_lines is not None:
            resolved_payload["max_lines"] = max_lines
        if overflow is not None:
            resolved_payload["overflow"] = overflow
        if size is not None:
            resolved_payload["size"] = size
        if text is not None:
            resolved_payload["text"] = text
        if value is not None:
            resolved_payload["value"] = value
        if weight is not None:
            resolved_payload["weight"] = weight
        super().__init__(
            *children,
            payload=resolved_payload,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_module_props(self, session: object, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        update_payload = dict(payload or {})
        if kwargs:
            update_payload.update(kwargs)
        return self.set_payload(session, update_payload)

    def emit_module_event(self, session: object, event: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.emit_event(session, event, payload, **kwargs)

    def run_module_action(self, session: object, action: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.run_action(session, action, payload, **kwargs)

    def contract(self) -> dict[str, object]:
        return self.describe_contract()


__all__ = ["Text"]
