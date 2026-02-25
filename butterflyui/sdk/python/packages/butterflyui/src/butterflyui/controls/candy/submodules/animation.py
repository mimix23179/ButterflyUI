from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CandySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "animation"


class Animation(CandySubmodule):
    """Candy submodule host control for `animation`."""

    control_type = "candy_animation"
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
        autoplay: bool | None = None,
        curve: str | None = None,
        duration_ms: int | None = None,
        loop: bool | None = None,
        opacity: int | float | None = None,
        reverse: bool | None = None,
        scale: int | float | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if autoplay is not None:
            resolved_payload["autoplay"] = autoplay
        if curve is not None:
            resolved_payload["curve"] = curve
        if duration_ms is not None:
            resolved_payload["duration_ms"] = duration_ms
        if loop is not None:
            resolved_payload["loop"] = loop
        if opacity is not None:
            resolved_payload["opacity"] = opacity
        if reverse is not None:
            resolved_payload["reverse"] = reverse
        if scale is not None:
            resolved_payload["scale"] = scale
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


__all__ = ["Animation"]
