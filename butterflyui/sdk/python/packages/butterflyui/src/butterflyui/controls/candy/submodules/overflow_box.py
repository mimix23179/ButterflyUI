from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CandySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "overflow_box"


class OverflowBox(CandySubmodule):
    """Candy submodule host control for `overflow_box`."""

    control_type = "candy_overflow_box"
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
        alignment: str | Mapping[str, object] | list[object] | None = None,
        max_height: int | float | str | None = None,
        max_width: int | float | str | None = None,
        min_height: int | float | str | None = None,
        min_width: int | float | str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if alignment is not None:
            resolved_payload["alignment"] = alignment
        if max_height is not None:
            resolved_payload["max_height"] = max_height
        if max_width is not None:
            resolved_payload["max_width"] = max_width
        if min_height is not None:
            resolved_payload["min_height"] = min_height
        if min_width is not None:
            resolved_payload["min_width"] = min_width
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


__all__ = ["OverflowBox"]
