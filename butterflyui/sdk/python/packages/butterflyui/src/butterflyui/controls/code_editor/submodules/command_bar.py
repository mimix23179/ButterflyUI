from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "command_bar"


class CommandBar(CodeEditorSubmodule):
    """CodeEditor submodule host control for `command_bar`."""

    control_type = "code_editor_command_bar"
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
        category: str | None = None,
        command: str | None = None,
        commands: list[object] | None = None,
        enabled_commands: list[object] | None = None,
        history: list[object] | None = None,
        input: str | None = None,
        placeholder: str | None = None,
        recent: list[object] | None = None,
        shortcut: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if category is not None:
            resolved_payload["category"] = category
        if command is not None:
            resolved_payload["command"] = command
        if commands is not None:
            resolved_payload["commands"] = commands
        if enabled_commands is not None:
            resolved_payload["enabled_commands"] = enabled_commands
        if history is not None:
            resolved_payload["history"] = history
        if input is not None:
            resolved_payload["input"] = input
        if placeholder is not None:
            resolved_payload["placeholder"] = placeholder
        if recent is not None:
            resolved_payload["recent"] = recent
        if shortcut is not None:
            resolved_payload["shortcut"] = shortcut
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


__all__ = ["CommandBar"]
