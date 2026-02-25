from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .._umbrella_runtime import (
    _normalize_engine,
    _normalize_events,
    _normalize_module,
    _normalize_state,
    _register_runtime_module,
    _normalize_token,
)

__all__ = [
    "CODE_EDITOR_SCHEMA_VERSION",
    "CODE_EDITOR_DEFAULT_ENGINE",
    "CODE_EDITOR_DEFAULT_WEBVIEW_ENGINE",
    "CODE_EDITOR_MODULES",
    "CODE_EDITOR_STATES",
    "CODE_EDITOR_EVENTS",
    "CODE_EDITOR_REGISTRY_ROLE_ALIASES",
    "CODE_EDITOR_REGISTRY_MANIFEST_LISTS",
    "CodeEditor",
]

CODE_EDITOR_SCHEMA_VERSION = 2
CODE_EDITOR_DEFAULT_ENGINE = "monaco"
CODE_EDITOR_DEFAULT_WEBVIEW_ENGINE = "windows_inapp"

CODE_EDITOR_MODULES = {
    "editor_intent_router",
    "editor_minimap",
    "editor_surface",
    "editor_view",
    "diff",
    "editor_tabs",
    "empty_state_view",
    "explorer_tree",
    "ide",
    "code_buffer",
    "code_category_layer",
    "code_document",
    "file_tabs",
    "file_tree",
    "smart_search_bar",
    "semantic_search",
    "search_box",
    "search_everything_panel",
    "search_field",
    "search_history",
    "search_intent",
    "search_item",
    "search_provider",
    "search_results_view",
    "search_scope_selector",
    "search_source",
    "query_token",
    "document_tab_strip",
    "command_search",
    "tree",
    "workbench_editor",
    "workspace_explorer",
    "command_bar",
    "diagnostic_stream",
    "diff_narrator",
    "dock_graph",
    "dock",
    "dock_pane",
    "empty_view",
    "export_panel",
    "gutter",
    "hint",
    "mini_map",
    "scope_picker",
    "scoped_search_replace",
    "diagnostics_panel",
    "ghost_editor",
    "inline_error_view",
    "inline_search_overlay",
    "inline_widget",
    "inspector",
    "intent_panel",
    "intent_router",
    "intent_search",
}

CODE_EDITOR_STATES = {"idle", "loading", "ready", "searching", "diff", "disabled"}

CODE_EDITOR_EVENTS = {
    "ready",
    "change",
    "submit",
    "save",
    "format_request",
    "search",
    "open_document",
    "close_document",
    "select",
    "state_change",
    "module_change",
}

CODE_EDITOR_REGISTRY_ROLE_ALIASES = {
    "module": "module_registry",
    "modules": "module_registry",
    "panel": "panel_registry",
    "panels": "panel_registry",
    "tool": "tool_registry",
    "tools": "tool_registry",
    "view": "view_registry",
    "views": "view_registry",
    "surface": "view_registry",
    "surfaces": "view_registry",
    "provider": "provider_registry",
    "providers": "provider_registry",
    "command": "command_registry",
    "commands": "command_registry",
    "module_registry": "module_registry",
    "panel_registry": "panel_registry",
    "tool_registry": "tool_registry",
    "view_registry": "view_registry",
    "provider_registry": "provider_registry",
    "command_registry": "command_registry",
}

CODE_EDITOR_REGISTRY_MANIFEST_LISTS = {
    "module_registry": "enabled_modules",
    "panel_registry": "enabled_panels",
    "tool_registry": "enabled_tools",
    "view_registry": "enabled_views",
    "provider_registry": "enabled_providers",
    "command_registry": "enabled_commands",
}

def _normalize_code_editor_engine(value: Any | None, *, fallback: str | None = None) -> str | None:
    normalized = _normalize_engine(value, fallback=fallback)
    if normalized is None:
        return None
    if normalized in {
        "flutter_monaco",
        "monaco_editor",
        "webview_windows",
        "webview_flutter",
        "windows",
        "flutter",
    }:
        return "monaco"
    return normalized


def _normalize_code_editor_webview_engine(
    value: Any | None, *, fallback: str | None = None
) -> str | None:
    normalized = _normalize_engine(value, fallback=fallback)
    if normalized is None:
        return None
    if normalized in {"windows_inapp"}:
        return "windows_inapp"
    if normalized in {
        "windows_inapp_monaco",
        "inapp",
        "monaco",
        "flutter_monaco",
        "monaco_editor",
    }:
        return "windows_inapp"
    if normalized in {
        "webview_windows",
        "windows",
    }:
        return "windows_inapp"
    if normalized in {
        "webview_flutter",
        "flutter",
    }:
        return "webview_flutter"
    return normalized

class CodeEditor(Component):
    control_type = "code_editor"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        code: str | None = None,
        language: str | None = None,
        read_only: bool | None = None,
        word_wrap: bool | None = None,
        line_numbers: bool | None = None,
        show_gutter: bool | None = None,
        show_minimap: bool | None = None,
        glyph_margin: bool | None = None,
        engine: str | None = None,
        webview_engine: str | None = None,
        document_uri: str | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        events: Iterable[str] | None = None,
        modules: Mapping[str, Any] | None = None,
        editor_intent_router: Mapping[str, Any] | None = None,
        editor_minimap: Mapping[str, Any] | None = None,
        editor_surface: Mapping[str, Any] | None = None,
        editor_view: Mapping[str, Any] | None = None,
        diff: Mapping[str, Any] | None = None,
        editor_tabs: Mapping[str, Any] | None = None,
        empty_state_view: Mapping[str, Any] | None = None,
        explorer_tree: Mapping[str, Any] | None = None,
        ide: Mapping[str, Any] | None = None,
        code_buffer: Mapping[str, Any] | None = None,
        code_category_layer: Mapping[str, Any] | None = None,
        code_document: Mapping[str, Any] | None = None,
        file_tabs: Mapping[str, Any] | None = None,
        file_tree: Mapping[str, Any] | None = None,
        smart_search_bar: Mapping[str, Any] | None = None,
        semantic_search: Mapping[str, Any] | None = None,
        search_box: Mapping[str, Any] | None = None,
        search_everything_panel: Mapping[str, Any] | None = None,
        search_field: Mapping[str, Any] | None = None,
        search_history: Mapping[str, Any] | None = None,
        search_intent: Mapping[str, Any] | None = None,
        search_item: Mapping[str, Any] | None = None,
        search_provider: Mapping[str, Any] | None = None,
        search_results_view: Mapping[str, Any] | None = None,
        search_scope_selector: Mapping[str, Any] | None = None,
        search_source: Mapping[str, Any] | None = None,
        query_token: Mapping[str, Any] | None = None,
        document_tab_strip: Mapping[str, Any] | None = None,
        command_search: Mapping[str, Any] | None = None,
        tree: Mapping[str, Any] | None = None,
        workbench_editor: Mapping[str, Any] | None = None,
        workspace_explorer: Mapping[str, Any] | None = None,
        command_bar: Mapping[str, Any] | None = None,
        diagnostic_stream: Mapping[str, Any] | None = None,
        diff_narrator: Mapping[str, Any] | None = None,
        dock_graph: Mapping[str, Any] | None = None,
        dock: Mapping[str, Any] | None = None,
        dock_pane: Mapping[str, Any] | None = None,
        empty_view: Mapping[str, Any] | None = None,
        export_panel: Mapping[str, Any] | None = None,
        gutter: Mapping[str, Any] | None = None,
        hint: Mapping[str, Any] | None = None,
        mini_map: Mapping[str, Any] | None = None,
        scope_picker: Mapping[str, Any] | None = None,
        scoped_search_replace: Mapping[str, Any] | None = None,
        diagnostics_panel: Mapping[str, Any] | None = None,
        ghost_editor: Mapping[str, Any] | None = None,
        inline_error_view: Mapping[str, Any] | None = None,
        inline_search_overlay: Mapping[str, Any] | None = None,
        inline_widget: Mapping[str, Any] | None = None,
        inspector: Mapping[str, Any] | None = None,
        intent_panel: Mapping[str, Any] | None = None,
        intent_router: Mapping[str, Any] | None = None,
        intent_search: Mapping[str, Any] | None = None,
        schema_version: int = CODE_EDITOR_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = code if code is not None else (text if text is not None else value)

        module_map: dict[str, Any] = {
            "editor_intent_router": editor_intent_router,
            "editor_minimap": editor_minimap,
            "editor_surface": editor_surface,
            "editor_view": editor_view,
            "diff": diff,
            "editor_tabs": editor_tabs,
            "empty_state_view": empty_state_view,
            "explorer_tree": explorer_tree,
            "ide": ide,
            "code_buffer": code_buffer,
            "code_category_layer": code_category_layer,
            "code_document": code_document,
            "file_tabs": file_tabs,
            "file_tree": file_tree,
            "smart_search_bar": smart_search_bar,
            "semantic_search": semantic_search,
            "search_box": search_box,
            "search_everything_panel": search_everything_panel,
            "search_field": search_field,
            "search_history": search_history,
            "search_intent": search_intent,
            "search_item": search_item,
            "search_provider": search_provider,
            "search_results_view": search_results_view,
            "search_scope_selector": search_scope_selector,
            "search_source": search_source,
            "query_token": query_token,
            "document_tab_strip": document_tab_strip,
            "command_search": command_search,
            "tree": tree,
            "workbench_editor": workbench_editor,
            "workspace_explorer": workspace_explorer,
            "command_bar": command_bar,
            "diagnostic_stream": diagnostic_stream,
            "diff_narrator": diff_narrator,
            "dock_graph": dock_graph,
            "dock": dock,
            "dock_pane": dock_pane,
            "empty_view": empty_view,
            "export_panel": export_panel,
            "gutter": gutter,
            "hint": hint,
            "mini_map": mini_map,
            "scope_picker": scope_picker,
            "scoped_search_replace": scoped_search_replace,
            "diagnostics_panel": diagnostics_panel,
            "ghost_editor": ghost_editor,
            "inline_error_view": inline_error_view,
            "inline_search_overlay": inline_search_overlay,
            "inline_widget": inline_widget,
            "inspector": inspector,
            "intent_panel": intent_panel,
            "intent_router": intent_router,
            "intent_search": intent_search,
        }

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, module_value in modules.items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in CODE_EDITOR_MODULES and module_value is not None:
                    merged_modules[normalized] = module_value
        for key, module_value in module_map.items():
            if module_value is not None:
                merged_modules[key] = module_value

        normalized_engine = _normalize_code_editor_engine(
            engine,
            fallback=CODE_EDITOR_DEFAULT_ENGINE,
        )
        normalized_webview_engine = _normalize_code_editor_webview_engine(
            webview_engine,
            fallback=CODE_EDITOR_DEFAULT_WEBVIEW_ENGINE,
        )

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            layout=layout,
            manifest=dict(kwargs.pop("manifest", {}) or {}),
            registries=dict(kwargs.pop("registries", {}) or {}),
            events=_normalize_events(events),
            value=resolved,
            text=resolved,
            code=resolved,
            language=language,
            read_only=read_only,
            word_wrap=word_wrap,
            line_numbers=line_numbers,
            show_gutter=show_gutter,
            show_minimap=show_minimap,
            glyph_margin=glyph_margin,
            engine=normalized_engine,
            webview_engine=normalized_webview_engine,
            document_uri=document_uri,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
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
            ensure_valid_props("code_editor", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise ValueError("\n".join(exc.errors)) from exc

    def set_module(self, session: Any, module: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        normalized = _normalize_module(module)
        if normalized is None or normalized not in CODE_EDITOR_MODULES:
            return {"ok": False, "error": f"Unknown code_editor module '{module}'"}
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
        if normalized is None or normalized not in CODE_EDITOR_STATES:
            return {"ok": False, "error": f"Unknown code_editor state '{state}'"}
        self.props["state"] = normalized
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_state", {"state": normalized})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def update_module(self, session: Any, module: str, **payload: Any) -> dict[str, Any]:
        return self.set_module(session, module, payload)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        if "module" in props:
            props["module"] = _normalize_module(props.get("module"))
        if "state" in props:
            props["state"] = _normalize_state(props.get("state"))
        if "engine" in props:
            props["engine"] = _normalize_code_editor_engine(
                props.get("engine"),
                fallback=str(self.props.get("engine") or CODE_EDITOR_DEFAULT_ENGINE),
            )
        if "webview_engine" in props:
            props["webview_engine"] = _normalize_code_editor_webview_engine(
                props.get("webview_engine"),
                fallback=str(
                    self.props.get("webview_engine") or CODE_EDITOR_DEFAULT_WEBVIEW_ENGINE
                ),
            )
        if "events" in props and isinstance(props.get("events"), Iterable):
            props["events"] = _normalize_events(props.get("events"))
        if "modules" in props and isinstance(props.get("modules"), Mapping):
            normalized_modules: dict[str, Any] = {}
            for key, value in dict(props["modules"]).items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in CODE_EDITOR_MODULES and value is not None:
                    normalized_modules[normalized] = value
            props["modules"] = normalized_modules
        next_props = dict(self.props)
        next_props.update({k: v for k, v in props.items() if v is not None})
        self._validate_props(next_props, strict=self._strict_contract)
        self.props.update({k: v for k, v in props.items() if v is not None})
        return self.invoke(session, "set_props", {"props": props})

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
            role_aliases=CODE_EDITOR_REGISTRY_ROLE_ALIASES,
            role_manifest_lists=CODE_EDITOR_REGISTRY_MANIFEST_LISTS,
            allowed_modules=CODE_EDITOR_MODULES,
            normalize_module=_normalize_module,
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

    def register_view(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="view",
            module_id=module_id,
            definition=definition,
        )

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

    def register_provider(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="provider",
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

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        event_name = _normalize_token(event)
        if event_name not in CODE_EDITOR_EVENTS:
            return {"ok": False, "error": f"Unknown code_editor event '{event}'"}
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

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        text_value = str(value)
        self.props["value"] = text_value
        self.props["text"] = text_value
        self.props["code"] = text_value
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_value", {"value": text_value})

    def set_text(self, session: Any, value: str) -> dict[str, Any]:
        return self.set_value(session, value)

    def set_code(self, session: Any, value: str) -> dict[str, Any]:
        return self.set_value(session, value)

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def select_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "select_all", {})

    def insert_text(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "insert_text", {"value": value})

    def format_document(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "format_document", {})

    def reveal_line(self, session: Any, line: int) -> dict[str, Any]:
        return self.invoke(session, "reveal_line", {"line": line})

    def set_markers(self, session: Any, markers: list[dict[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_markers", {"markers": markers})
