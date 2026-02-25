from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "editor_intent_router"


class EditorIntentRouter(CodeEditorSubmodule):
    """CodeEditor submodule host control for `editor_intent_router`."""

    control_type = "code_editor_editor_intent_router"
    umbrella = "code_editor"
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN

    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))
    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))
    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))
    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))

    def __init__(
        self,
        payload: Mapping[str, object] | None = None,
        props: Mapping[str, object] | None = None,
        style: Mapping[str, object] | None = None,
        strict: bool = False,
        active_intent: str | None = None,
        confidence: int | float | None = None,
        history: list[object] | None = None,
        intent: str | None = None,
        intents: list[object] | None = None,
        resolver: Mapping[str, object] | None = None,
        route: str | None = None,
        routes: list[object] | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if active_intent is not None:
            resolved_payload["active_intent"] = active_intent
        if confidence is not None:
            resolved_payload["confidence"] = confidence
        if history is not None:
            resolved_payload["history"] = history
        if intent is not None:
            resolved_payload["intent"] = intent
        if intents is not None:
            resolved_payload["intents"] = intents
        if resolver is not None:
            resolved_payload["resolver"] = resolver
        if route is not None:
            resolved_payload["route"] = route
        if routes is not None:
            resolved_payload["routes"] = routes
        super().__init__(
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


__all__ = ["EditorIntentRouter"]
