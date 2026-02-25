from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import CodeEditorSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "dock"


class Dock(CodeEditorSubmodule):
    """CodeEditor submodule host control for `dock`."""

    control_type = "code_editor_dock"
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
        active_pane: str | None = None,
        dock_id: str | None = None,
        floating: bool | None = None,
        layout: Mapping[str, object] | None = None,
        orientation: str | None = None,
        panes: list[object] | None = None,
        pinned: bool | None = None,
        sizes: list[object] | None = None,
        target: str | None = None,
        zone: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if active_pane is not None:
            resolved_payload["active_pane"] = active_pane
        if dock_id is not None:
            resolved_payload["dock_id"] = dock_id
        if floating is not None:
            resolved_payload["floating"] = floating
        if layout is not None:
            resolved_payload["layout"] = layout
        if orientation is not None:
            resolved_payload["orientation"] = orientation
        if panes is not None:
            resolved_payload["panes"] = panes
        if pinned is not None:
            resolved_payload["pinned"] = pinned
        if sizes is not None:
            resolved_payload["sizes"] = sizes
        if target is not None:
            resolved_payload["target"] = target
        if zone is not None:
            resolved_payload["zone"] = zone
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


__all__ = ["Dock"]
