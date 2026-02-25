from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CandySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "decorated_box"


class DecoratedBox(CandySubmodule):
    """Candy submodule host control for `decorated_box`."""

    control_type = "candy_decorated_box"
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
        bgcolor: str | int | None = None,
        border_color: str | int | None = None,
        border_width: int | float | None = None,
        gradient: object | None = None,
        radius: int | float | None = None,
        shadow: object | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if bgcolor is not None:
            resolved_payload["bgcolor"] = bgcolor
        if border_color is not None:
            resolved_payload["border_color"] = border_color
        if border_width is not None:
            resolved_payload["border_width"] = border_width
        if gradient is not None:
            resolved_payload["gradient"] = gradient
        if radius is not None:
            resolved_payload["radius"] = radius
        if shadow is not None:
            resolved_payload["shadow"] = shadow
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


__all__ = ["DecoratedBox"]
