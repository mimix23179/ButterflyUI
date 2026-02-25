from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import StudioSubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = 'bindings_editor'


class BindingsEditor(StudioSubmodule):
    """Studio submodule host control for `bindings_editor`."""

    control_type = 'studio_bindings_editor'
    umbrella = 'studio'
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN
    module_id = MODULE_TOKEN
    module_version = '1.0.0'
    module_depends_on = ()
    module_contributions = {}

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
        actions: list[object] | None = None,
        active_document: str | None = None,
        active_surface: str | None = None,
        assets: list[object] | None = None,
        bindings: Mapping[str, object] | None = None,
        bottom_panel_height: int | float | None = None,
        command_registry: Mapping[str, object] | None = None,
        custom_layout: bool | None = None,
        dirty: bool | None = None,
        documents: list[object] | None = None,
        exporter_registry: Mapping[str, object] | None = None,
        focused_panel: str | None = None,
        history: list[object] | None = None,
        importer_registry: Mapping[str, object] | None = None,
        input: object | None = None,
        layout: str | None = None,
        left_pane_ratio: int | float | None = None,
        manifest: Mapping[str, object] | None = None,
        modules: Mapping[str, object] | None = None,
        panel_registry: Mapping[str, object] | None = None,
        query: str | None = None,
        radius: int | float | None = None,
        read_only: bool | None = None,
        redo_stack: list[object] | None = None,
        registries: Mapping[str, object] | None = None,
        right_pane_ratio: int | float | None = None,
        schema: Mapping[str, object] | None = None,
        schema_registry: Mapping[str, object] | None = None,
        show_chrome: bool | None = None,
        show_modules: bool | None = None,
        surface_registry: Mapping[str, object] | None = None,
        tokens: Mapping[str, object] | None = None,
        tool_registry: Mapping[str, object] | None = None,
        undo_stack: list[object] | None = None,
        value: object | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if actions is not None:
            resolved_payload['actions'] = actions
        if active_document is not None:
            resolved_payload['active_document'] = active_document
        if active_surface is not None:
            resolved_payload['active_surface'] = active_surface
        if assets is not None:
            resolved_payload['assets'] = assets
        if bindings is not None:
            resolved_payload['bindings'] = bindings
        if bottom_panel_height is not None:
            resolved_payload['bottom_panel_height'] = bottom_panel_height
        if command_registry is not None:
            resolved_payload['command_registry'] = command_registry
        if custom_layout is not None:
            resolved_payload['custom_layout'] = custom_layout
        if dirty is not None:
            resolved_payload['dirty'] = dirty
        if documents is not None:
            resolved_payload['documents'] = documents
        if exporter_registry is not None:
            resolved_payload['exporter_registry'] = exporter_registry
        if focused_panel is not None:
            resolved_payload['focused_panel'] = focused_panel
        if history is not None:
            resolved_payload['history'] = history
        if importer_registry is not None:
            resolved_payload['importer_registry'] = importer_registry
        if input is not None:
            resolved_payload['input'] = input
        if layout is not None:
            resolved_payload['layout'] = layout
        if left_pane_ratio is not None:
            resolved_payload['left_pane_ratio'] = left_pane_ratio
        if manifest is not None:
            resolved_payload['manifest'] = manifest
        if modules is not None:
            resolved_payload['modules'] = modules
        if panel_registry is not None:
            resolved_payload['panel_registry'] = panel_registry
        if query is not None:
            resolved_payload['query'] = query
        if radius is not None:
            resolved_payload['radius'] = radius
        if read_only is not None:
            resolved_payload['read_only'] = read_only
        if redo_stack is not None:
            resolved_payload['redo_stack'] = redo_stack
        if registries is not None:
            resolved_payload['registries'] = registries
        if right_pane_ratio is not None:
            resolved_payload['right_pane_ratio'] = right_pane_ratio
        if schema is not None:
            resolved_payload['schema'] = schema
        if schema_registry is not None:
            resolved_payload['schema_registry'] = schema_registry
        if show_chrome is not None:
            resolved_payload['show_chrome'] = show_chrome
        if show_modules is not None:
            resolved_payload['show_modules'] = show_modules
        if surface_registry is not None:
            resolved_payload['surface_registry'] = surface_registry
        if tokens is not None:
            resolved_payload['tokens'] = tokens
        if tool_registry is not None:
            resolved_payload['tool_registry'] = tool_registry
        if undo_stack is not None:
            resolved_payload['undo_stack'] = undo_stack
        if value is not None:
            resolved_payload['value'] = value
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


__all__ = ['BindingsEditor']
