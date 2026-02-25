from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .._umbrella_runtime import (
    _normalize_events,
    _normalize_module,
    _normalize_state,
    _normalize_token,
    _register_runtime_module,
)

__all__ = [
    "STUDIO_SCHEMA_VERSION",
    "STUDIO_MODULES",
    "STUDIO_STATES",
    "STUDIO_EVENTS",
    "STUDIO_MODULE_ALIASES",
    "STUDIO_REGISTRY_ROLE_ALIASES",
    "STUDIO_REGISTRY_MANIFEST_LISTS",
    "Studio",
]

STUDIO_SCHEMA_VERSION = 2

STUDIO_MODULES = {
    "builder",
    "canvas",
    "canvas_surface",
    "timeline_surface",
    "node_surface",
    "preview_surface",
    "block_palette",
    "component_palette",
    "inspector",
    "outline_tree",
    "project_panel",
    "properties_panel",
    "responsive_toolbar",
    "tokens_editor",
    "actions_editor",
    "bindings_editor",
    "asset_browser",
    "selection_tools",
    "transform_box",
    "transform_toolbar",
    "assets",
    "assets_panel",
    "layers",
    "layers_panel",
    "node",
    "node_graph",
    "preview",
    "properties",
    "responsive",
    "timeline",
    "timeline_editor",
    "token_editor",
    "tokens",
    "toolbox",
    "transform",
    "transform_tools",
}

STUDIO_STATES = {"idle", "loading", "ready", "editing", "preview", "disabled"}

STUDIO_EVENTS = {
    "ready",
    "change",
    "submit",
    "select",
    "state_change",
    "module_change",
}

STUDIO_MODULE_ALIASES = {
    "builder_surface": "builder",
}

STUDIO_REGISTRY_ROLE_ALIASES = {
    "surface": "surface_registry",
    "surfaces": "surface_registry",
    "surface_registry": "surface_registry",
    "tool": "tool_registry",
    "tools": "tool_registry",
    "tool_registry": "tool_registry",
    "panel": "panel_registry",
    "panels": "panel_registry",
    "panel_registry": "panel_registry",
    "importer": "importer_registry",
    "importers": "importer_registry",
    "importer_registry": "importer_registry",
    "exporter": "exporter_registry",
    "exporters": "exporter_registry",
    "exporter_registry": "exporter_registry",
    "command": "command_registry",
    "commands": "command_registry",
    "command_registry": "command_registry",
    "schema": "schema_registry",
    "schemas": "schema_registry",
    "schema_registry": "schema_registry",
    "compute": "command_registry",
    "module": "module_registry",
    "modules": "module_registry",
    "module_registry": "module_registry",
}

STUDIO_REGISTRY_MANIFEST_LISTS = {
    "surface_registry": "enabled_surfaces",
    "panel_registry": "enabled_panels",
    "tool_registry": "enabled_tools",
    "importer_registry": "importers",
    "exporter_registry": "exporters",
    "module_registry": "enabled_modules",
}

def _normalize_studio_module(value: str | None) -> str | None:
    normalized = _normalize_module(value)
    if normalized is None:
        return None
    return STUDIO_MODULE_ALIASES.get(normalized, normalized)

class Studio(Component):
    control_type = "studio"

    def __init__(
        self,
        *,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        show_modules: bool | None = None,
        show_chrome: bool | None = None,
        radius: float | None = None,
        events: Iterable[str] | None = None,
        modules: Mapping[str, Any] | None = None,
        actions_editor: Mapping[str, Any] | None = None,
        asset_browser: Mapping[str, Any] | None = None,
        bindings_editor: Mapping[str, Any] | None = None,
        block_palette: Mapping[str, Any] | None = None,
        builder: Mapping[str, Any] | None = None,
        canvas: Mapping[str, Any] | None = None,
        timeline_surface: Mapping[str, Any] | None = None,
        node_surface: Mapping[str, Any] | None = None,
        preview_surface: Mapping[str, Any] | None = None,
        component_palette: Mapping[str, Any] | None = None,
        inspector: Mapping[str, Any] | None = None,
        outline_tree: Mapping[str, Any] | None = None,
        project_panel: Mapping[str, Any] | None = None,
        properties_panel: Mapping[str, Any] | None = None,
        responsive_toolbar: Mapping[str, Any] | None = None,
        tokens_editor: Mapping[str, Any] | None = None,
        selection_tools: Mapping[str, Any] | None = None,
        transform_box: Mapping[str, Any] | None = None,
        transform_toolbar: Mapping[str, Any] | None = None,
        manifest: Mapping[str, Any] | None = None,
        registries: Mapping[str, Any] | None = None,
        panels: Mapping[str, Any] | None = None,
        shortcuts: Mapping[str, Any] | None = None,
        render: Mapping[str, Any] | None = None,
        cache: Mapping[str, Any] | None = None,
        media: Mapping[str, Any] | None = None,
        documents: list[Any] | None = None,
        assets: list[Any] | None = None,
        left_pane_ratio: float | None = None,
        right_pane_ratio: float | None = None,
        bottom_panel_height: float | None = None,
        schema_version: int = STUDIO_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        module_map: dict[str, Any] = {
            "actions_editor": actions_editor,
            "asset_browser": asset_browser,
            "bindings_editor": bindings_editor,
            "block_palette": block_palette,
            "builder": builder,
            "canvas": canvas,
            "timeline_surface": timeline_surface,
            "node_surface": node_surface,
            "preview_surface": preview_surface,
            "component_palette": component_palette,
            "inspector": inspector,
            "outline_tree": outline_tree,
            "project_panel": project_panel,
            "properties_panel": properties_panel,
            "responsive_toolbar": responsive_toolbar,
            "tokens_editor": tokens_editor,
            "selection_tools": selection_tools,
            "transform_box": transform_box,
            "transform_toolbar": transform_toolbar,
        }

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, module_value in modules.items():
                normalized = _normalize_studio_module(str(key))
                if normalized and normalized in STUDIO_MODULES and module_value is not None:
                    merged_modules[normalized] = module_value
        for key, module_value in module_map.items():
            if module_value is not None:
                merged_modules[key] = module_value

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_studio_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            layout=layout,
            show_modules=show_modules,
            show_chrome=show_chrome,
            radius=radius,
            manifest=dict(manifest or {}),
            registries=dict(registries or {}),
            panels=dict(panels or {}),
            shortcuts=dict(shortcuts or {}),
            render=dict(render or {}),
            cache=dict(cache or {}),
            media=dict(media or {}),
            documents=documents,
            assets=assets,
            left_pane_ratio=left_pane_ratio,
            right_pane_ratio=right_pane_ratio,
            bottom_panel_height=bottom_panel_height,
            events=_normalize_events(events),
            modules=merged_modules,
            **merged_modules,
            **kwargs,
        )
        self._strict_contract = strict
        self._validate_props(merged, strict=strict)
        super().__init__(props=merged, style=style, strict=strict)

    @staticmethod
    def _validate_props(props: Mapping[str, Any], *, strict: bool) -> None:
        try:
            ensure_valid_props("studio", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise ValueError("\n".join(exc.errors)) from exc

    def set_module(self, session: Any, module: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        normalized = _normalize_studio_module(module)
        if normalized is None or normalized not in STUDIO_MODULES:
            return {"ok": False, "error": f"Unknown studio module '{module}'"}
        payload_dict = dict(payload or {})
        self.props["module"] = normalized
        modules = dict(self.props.get("modules") or {})
        modules[normalized] = payload_dict
        self.props["modules"] = modules
        self.props[normalized] = payload_dict
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_module", {"module": normalized, "payload": payload_dict})

    def set_state(self, session: Any, state: str) -> dict[str, Any]:
        normalized = _normalize_state(state)
        if normalized is None or normalized not in STUDIO_STATES:
            return {"ok": False, "error": f"Unknown studio state '{state}'"}
        self.props["state"] = normalized
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_state", {"state": normalized})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def update_module(self, session: Any, module: str, **payload: Any) -> dict[str, Any]:
        return self.set_module(session, module, payload)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        if "module" in props:
            props["module"] = _normalize_studio_module(props.get("module"))
        if "state" in props:
            props["state"] = _normalize_state(props.get("state"))
        if "events" in props and isinstance(props.get("events"), Iterable):
            props["events"] = _normalize_events(props.get("events"))
        if "modules" in props and isinstance(props.get("modules"), Mapping):
            normalized_modules: dict[str, Any] = {}
            for key, value in dict(props["modules"]).items():
                normalized = _normalize_studio_module(str(key))
                if normalized and normalized in STUDIO_MODULES and value is not None:
                    normalized_modules[normalized] = value
            props["modules"] = normalized_modules
        next_props = dict(self.props)
        next_props.update({k: v for k, v in props.items() if v is not None})
        self._validate_props(next_props, strict=self._strict_contract)
        self.props.update({k: v for k, v in props.items() if v is not None})
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        event_name = _normalize_token(event)
        if event_name not in STUDIO_EVENTS:
            return {"ok": False, "error": f"Unknown studio event '{event}'"}
        return self.invoke(
            session,
            "emit",
            {
                "event": event_name,
                "payload": dict(payload or {}),
            },
        )

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)

    def set_manifest(self, session: Any, manifest: Mapping[str, Any]) -> dict[str, Any]:
        manifest_payload = dict(manifest or {})
        current_manifest = dict(self.props.get("manifest") or {})
        current_manifest.update(manifest_payload)
        self.props["manifest"] = current_manifest
        return self.invoke(session, "set_manifest", {"manifest": manifest_payload})

    def register_module(
        self,
        session: Any,
        *,
        role: str,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        result = _register_runtime_module(
            self.props,
            role=role,
            module_id=module_id,
            definition=definition,
            role_aliases=STUDIO_REGISTRY_ROLE_ALIASES,
            role_manifest_lists=STUDIO_REGISTRY_MANIFEST_LISTS,
            allowed_modules=STUDIO_MODULES,
            normalize_module=_normalize_studio_module,
        )
        if result.get("ok") is not True:
            return result
        return self.invoke(
            session,
            "register_module",
            {
                "role": result["role"],
                "module_id": result["module_id"],
                "definition": dict(definition or {}),
            },
        )

    def set_selection(
        self,
        session: Any,
        *,
        selected_id: str | None = None,
        selected_ids: Iterable[str] | None = None,
        active_tool: str | None = None,
        active_surface: str | None = None,
        focused_panel: str | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        selection_payload = dict(self.props.get("selection_tools") or {})
        if selected_id is not None:
            payload["selected_id"] = selected_id
            selection_payload["selected_id"] = selected_id
        if selected_ids is not None:
            ids_list = list(selected_ids)
            payload["selected_ids"] = ids_list
            selection_payload["selected_ids"] = ids_list
        if active_tool is not None:
            payload["active_tool"] = active_tool
            selection_payload["active_tool"] = active_tool
        if active_surface is not None:
            normalized_surface = _normalize_studio_module(active_surface)
            if normalized_surface is None or normalized_surface not in STUDIO_MODULES:
                return {"ok": False, "error": f"Unknown studio surface '{active_surface}'"}
            payload["active_surface"] = normalized_surface
            selection_payload["active_surface"] = normalized_surface
            self.props["module"] = normalized_surface
        if focused_panel is not None:
            normalized_panel = _normalize_studio_module(focused_panel)
            if normalized_panel is None or normalized_panel not in STUDIO_MODULES:
                return {"ok": False, "error": f"Unknown studio panel '{focused_panel}'"}
            payload["focused_panel"] = normalized_panel
            selection_payload["focused_panel"] = normalized_panel

        modules = dict(self.props.get("modules") or {})
        existing_selection = dict(modules.get("selection_tools") or {})
        existing_selection.update(selection_payload)
        modules["selection_tools"] = existing_selection
        self.props["modules"] = modules
        self.props["selection_tools"] = existing_selection
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_selection", payload)

    def set_tool(self, session: Any, tool: str) -> dict[str, Any]:
        modules = dict(self.props.get("modules") or {})
        selection_payload = dict(modules.get("selection_tools") or {})
        selection_payload["active_tool"] = tool
        modules["selection_tools"] = selection_payload
        self.props["modules"] = modules
        self.props["selection_tools"] = selection_payload
        self.props["active_tool"] = tool
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_tool", {"tool": tool})

    def activate_tool(self, session: Any, tool: str) -> dict[str, Any]:
        modules = dict(self.props.get("modules") or {})
        selection_payload = dict(modules.get("selection_tools") or {})
        selection_payload["active_tool"] = tool
        modules["selection_tools"] = selection_payload
        self.props["modules"] = modules
        self.props["selection_tools"] = selection_payload
        self.props["active_tool"] = tool
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "activate_tool", {"tool": tool})

    def set_active_surface(self, session: Any, surface: str) -> dict[str, Any]:
        normalized = _normalize_studio_module(surface)
        if normalized is None:
            return {"ok": False, "error": "surface is required"}
        if normalized not in STUDIO_MODULES:
            return {"ok": False, "error": f"Unknown studio surface '{surface}'"}
        self.props["module"] = normalized
        modules = dict(self.props.get("modules") or {})
        selection_payload = dict(modules.get("selection_tools") or {})
        selection_payload["active_surface"] = normalized
        modules["selection_tools"] = selection_payload
        self.props["modules"] = modules
        self.props["selection_tools"] = selection_payload
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(
            session,
            "set_active_surface",
            {"surface": normalized},
        )

    def focus_panel(self, session: Any, panel: str) -> dict[str, Any]:
        normalized = _normalize_studio_module(panel)
        if normalized is None:
            return {"ok": False, "error": "panel is required"}
        modules = dict(self.props.get("modules") or {})
        selection_payload = dict(modules.get("selection_tools") or {})
        selection_payload["focused_panel"] = normalized
        modules["selection_tools"] = selection_payload
        self.props["modules"] = modules
        self.props["selection_tools"] = selection_payload
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "focus_panel", {"panel": normalized})

    def register_surface(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="surface",
            module_id=module_id,
            definition=definition,
        )

    def register_tool(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="tool",
            module_id=module_id,
            definition=definition,
        )

    def register_panel(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="panel",
            module_id=module_id,
            definition=definition,
        )

    def register_importer(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="importer",
            module_id=module_id,
            definition=definition,
        )

    def register_exporter(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="exporter",
            module_id=module_id,
            definition=definition,
        )

    def register_command(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="command",
            module_id=module_id,
            definition=definition,
        )

    def register_schema(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="schema",
            module_id=module_id,
            definition=definition,
        )

    def register_compute(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="compute",
            module_id=module_id,
            definition=definition,
        )

    def register_shortcut(
        self,
        session: Any,
        *,
        context: str,
        chord: str,
        command: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "register_shortcut",
            {
                "context": context,
                "chord": chord,
                "command": command,
                "payload": dict(payload or {}),
            },
        )

    def set_dock_layout(self, session: Any, layout: Mapping[str, Any]) -> dict[str, Any]:
        payload = dict(layout)
        self.props["layout"] = payload
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_dock_layout", {"layout": payload})

    def import_asset(
        self,
        session: Any,
        *,
        path: str,
        mode: str = "copy",
        metadata: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "import_asset",
            {
                "path": path,
                "mode": mode,
                "metadata": dict(metadata or {}),
            },
        )

    def enqueue_export(
        self,
        session: Any,
        *,
        format: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "enqueue_export",
            {
                "format": format,
                "payload": dict(payload or {}),
            },
        )

    def export(
        self,
        session: Any,
        *,
        format: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "export",
            {
                "format": format,
                "payload": dict(payload or {}),
            },
        )

    def set_zoom(self, session: Any, zoom: float) -> dict[str, Any]:
        zoom_value = float(zoom)
        modules = dict(self.props.get("modules") or {})
        responsive_source = modules.get("responsive_toolbar")
        if not isinstance(responsive_source, Mapping):
            responsive_source = self.props.get("responsive_toolbar")
        responsive = dict(responsive_source) if isinstance(responsive_source, Mapping) else {}
        responsive["zoom"] = zoom_value
        modules["responsive_toolbar"] = responsive
        self.props["modules"] = modules
        self.props["responsive_toolbar"] = responsive
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_zoom", {"zoom": zoom_value})

    def set_viewport(
        self,
        session: Any,
        *,
        width: float,
        height: float,
        device: str | None = None,
        portrait: bool | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {
            "width": float(width),
            "height": float(height),
        }
        if device is not None:
            payload["device"] = device
        if portrait is not None:
            payload["portrait"] = bool(portrait)

        modules = dict(self.props.get("modules") or {})
        responsive_source = modules.get("responsive_toolbar")
        if not isinstance(responsive_source, Mapping):
            responsive_source = self.props.get("responsive_toolbar")
        responsive = dict(responsive_source) if isinstance(responsive_source, Mapping) else {}
        responsive["width"] = payload["width"]
        responsive["height"] = payload["height"]
        if "device" in payload:
            responsive["device"] = payload["device"]
        if "portrait" in payload:
            responsive["portrait"] = payload["portrait"]
        modules["responsive_toolbar"] = responsive
        self.props["modules"] = modules
        self.props["responsive_toolbar"] = responsive
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_viewport", payload)

    def set_prop(self, session: Any, key: str, value: Any) -> dict[str, Any]:
        normalized_key = str(key).strip()
        if not normalized_key:
            return {"ok": False, "error": "key is required"}
        self.props[normalized_key] = value
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_prop", {"key": normalized_key, "value": value})

    def begin_transaction(self, session: Any, label: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if label:
            payload["label"] = label
        return self.invoke(session, "begin_transaction", payload)

    def end_transaction(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "end_transaction", {})

    def set_playback(
        self,
        session: Any,
        payload: Mapping[str, Any] | None = None,
        **kwargs: Any,
    ) -> dict[str, Any]:
        playback_payload = dict(payload or {})
        for key, value in kwargs.items():
            if value is not None:
                playback_payload[key] = value
        media = dict(self.props.get("media") or {})
        media["playback"] = playback_payload
        self.props["media"] = media
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_playback", playback_payload)

    def ffmpeg_enqueue(
        self,
        session: Any,
        *,
        command: str,
        args: Iterable[str] | None = None,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        request = dict(payload or {})
        request["command"] = command
        if args is not None:
            request["args"] = [str(item) for item in args]
        return self.invoke(session, "ffmpeg_enqueue", request)

    def execute_command(
        self,
        session: Any,
        *,
        command_type: str,
        payload: Mapping[str, Any] | None = None,
        label: str | None = None,
    ) -> dict[str, Any]:
        data: dict[str, Any] = {"type": command_type, "payload": dict(payload or {})}
        if label:
            data["label"] = label
        return self.invoke(session, "execute_command", data)

    def undo(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "undo", {})

    def redo(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "redo", {})
