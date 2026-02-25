from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "search_everything_panel"


class SearchEverythingPanel(CodeEditorSubmodule):
    """CodeEditor submodule host control for `search_everything_panel`."""

    control_type = "code_editor_search_everything_panel"
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
        case_sensitive: bool | None = None,
        filters: Mapping[str, object] | None = None,
        highlight: bool | None = None,
        history: list[object] | None = None,
        limit: int | None = None,
        loading: bool | None = None,
        offset: int | None = None,
        provider: str | None = None,
        query: str | None = None,
        regex: bool | None = None,
        replace: str | None = None,
        results: list[object] | None = None,
        scope: str | None = None,
        source: str | None = None,
        tokens: list[object] | None = None,
        whole_word: bool | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if case_sensitive is not None:
            resolved_payload["case_sensitive"] = case_sensitive
        if filters is not None:
            resolved_payload["filters"] = filters
        if highlight is not None:
            resolved_payload["highlight"] = highlight
        if history is not None:
            resolved_payload["history"] = history
        if limit is not None:
            resolved_payload["limit"] = limit
        if loading is not None:
            resolved_payload["loading"] = loading
        if offset is not None:
            resolved_payload["offset"] = offset
        if provider is not None:
            resolved_payload["provider"] = provider
        if query is not None:
            resolved_payload["query"] = query
        if regex is not None:
            resolved_payload["regex"] = regex
        if replace is not None:
            resolved_payload["replace"] = replace
        if results is not None:
            resolved_payload["results"] = results
        if scope is not None:
            resolved_payload["scope"] = scope
        if source is not None:
            resolved_payload["source"] = source
        if tokens is not None:
            resolved_payload["tokens"] = tokens
        if whole_word is not None:
            resolved_payload["whole_word"] = whole_word
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


__all__ = ["SearchEverythingPanel"]
