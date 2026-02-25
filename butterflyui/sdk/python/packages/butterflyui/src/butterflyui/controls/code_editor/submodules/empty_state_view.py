from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "empty_state_view"


class EmptyStateView(CodeEditorSubmodule):
    """CodeEditor submodule host control for `empty_state_view`."""

    control_type = "code_editor_empty_state_view"
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
        cta_action: str | None = None,
        cta_label: str | None = None,
        message: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if cta_action is not None:
            resolved_payload["cta_action"] = cta_action
        if cta_label is not None:
            resolved_payload["cta_label"] = cta_label
        if message is not None:
            resolved_payload["message"] = message
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


__all__ = ["EmptyStateView"]
