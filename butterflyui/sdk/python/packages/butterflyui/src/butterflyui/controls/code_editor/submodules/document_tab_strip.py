from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "document_tab_strip"


class DocumentTabStrip(CodeEditorSubmodule):
    """CodeEditor submodule host control for `document_tab_strip`."""

    control_type = "code_editor_document_tab_strip"
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
        active_tab: object | None = None,
        closable: bool | None = None,
        draggable: bool | None = None,
        multi_select: bool | None = None,
        pinned_tabs: list[object] | None = None,
        reorderable: bool | None = None,
        show_dirty: bool | None = None,
        show_icons: bool | None = None,
        tabs: list[object] | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if active_tab is not None:
            resolved_payload["active_tab"] = active_tab
        if closable is not None:
            resolved_payload["closable"] = closable
        if draggable is not None:
            resolved_payload["draggable"] = draggable
        if multi_select is not None:
            resolved_payload["multi_select"] = multi_select
        if pinned_tabs is not None:
            resolved_payload["pinned_tabs"] = pinned_tabs
        if reorderable is not None:
            resolved_payload["reorderable"] = reorderable
        if show_dirty is not None:
            resolved_payload["show_dirty"] = show_dirty
        if show_icons is not None:
            resolved_payload["show_icons"] = show_icons
        if tabs is not None:
            resolved_payload["tabs"] = tabs
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


__all__ = ["DocumentTabStrip"]
