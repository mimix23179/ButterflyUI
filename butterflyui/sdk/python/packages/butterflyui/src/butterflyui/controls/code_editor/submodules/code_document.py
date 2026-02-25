from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "code_document"


class CodeDocument(CodeEditorSubmodule):
    """CodeEditor submodule host control for `code_document`."""

    control_type = "code_editor_code_document"
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
        content: object | None = None,
        dirty: bool | None = None,
        encoding: str | None = None,
        language: str | None = None,
        mtime: object | None = None,
        name: str | None = None,
        path: str | None = None,
        read_only: bool | None = None,
        size: int | None = None,
        text: str | None = None,
        uri: str | None = None,
        value: str | None = None,
        version: int | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if code is not None:
            resolved_payload["code"] = code
        if content is not None:
            resolved_payload["content"] = content
        if dirty is not None:
            resolved_payload["dirty"] = dirty
        if encoding is not None:
            resolved_payload["encoding"] = encoding
        if language is not None:
            resolved_payload["language"] = language
        if mtime is not None:
            resolved_payload["mtime"] = mtime
        if name is not None:
            resolved_payload["name"] = name
        if path is not None:
            resolved_payload["path"] = path
        if read_only is not None:
            resolved_payload["read_only"] = read_only
        if size is not None:
            resolved_payload["size"] = size
        if text is not None:
            resolved_payload["text"] = text
        if uri is not None:
            resolved_payload["uri"] = uri
        if value is not None:
            resolved_payload["value"] = value
        if version is not None:
            resolved_payload["version"] = version
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


__all__ = ["CodeDocument"]
