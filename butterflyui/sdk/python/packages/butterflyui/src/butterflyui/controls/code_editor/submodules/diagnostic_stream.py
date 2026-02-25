from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "diagnostic_stream"


class DiagnosticStream(CodeEditorSubmodule):
    """CodeEditor submodule host control for `diagnostic_stream`."""

    control_type = "code_editor_diagnostic_stream"
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
        code: str | None = None,
        column: int | None = None,
        counts: Mapping[str, object] | None = None,
        diagnostics: list[object] | None = None,
        items: list[object] | None = None,
        line: int | None = None,
        markers: list[object] | None = None,
        message: str | None = None,
        range: Mapping[str, object] | None = None,
        severity: str | None = None,
        source: str | None = None,
        summary: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if code is not None:
            resolved_payload["code"] = code
        if column is not None:
            resolved_payload["column"] = column
        if counts is not None:
            resolved_payload["counts"] = counts
        if diagnostics is not None:
            resolved_payload["diagnostics"] = diagnostics
        if items is not None:
            resolved_payload["items"] = items
        if line is not None:
            resolved_payload["line"] = line
        if markers is not None:
            resolved_payload["markers"] = markers
        if message is not None:
            resolved_payload["message"] = message
        if range is not None:
            resolved_payload["range"] = range
        if severity is not None:
            resolved_payload["severity"] = severity
        if source is not None:
            resolved_payload["source"] = source
        if summary is not None:
            resolved_payload["summary"] = summary
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


__all__ = ["DiagnosticStream"]
