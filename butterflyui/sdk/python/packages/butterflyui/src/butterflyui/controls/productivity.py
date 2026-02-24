from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ..core.schema import ButterflyUIContractError, ensure_valid_props
from ._shared import Component, merge_props

__all__ = [
    "Chat",
    "ChatBubble",
    "MessageBubble",
    "CodeEditor",
    "Studio",
    "Terminal",
    "OutputPanel",
    "EditorTabStrip",
    "WorkspaceTree",
    "FileSystem",
    "ProblemsPanel",
    "EditorWorkspace",
    "OwnershipMarker",
    "ChatThread",
    "ChatMessage",
    "MessageComposer",
    "PromptComposer",
    "Form",
    "AutoForm",
    "SubmitScope",
    "FormField",
    "ValidationSummary",
]


class OwnershipMarker(Component):
    control_type = "ownership_marker"

    def __init__(
        self,
        *,
        document_id: str | None = None,
        items: list[Mapping[str, Any]] | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            document_id=document_id,
            items=[dict(item) for item in (items or [])],
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


CODE_EDITOR_SCHEMA_VERSION = 2

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

STUDIO_SCHEMA_VERSION = 2

STUDIO_MODULES = {
    "actions_editor",
    "asset_browser",
    "bindings_editor",
    "block_palette",
    "builder",
    "canvas",
    "component_palette",
    "inspector",
    "outline_tree",
    "project_panel",
    "properties_panel",
    "responsive_toolbar",
    "tokens_editor",
    "selection_tools",
    "transform_box",
    "transform_toolbar",
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


def _normalize_token(value: str | None) -> str:
    if value is None:
        return ""
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _normalize_module(value: str | None) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return normalized


def _normalize_state(value: str | None) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return normalized


def _normalize_events(values: Iterable[Any] | None) -> list[str] | None:
    if values is None:
        return None
    out: list[str] = []
    for entry in values:
        value = _normalize_token(str(entry))
        if value and value not in out:
            out.append(value)
    return out


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

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            layout=layout,
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
            engine=engine,
            webview_engine=webview_engine,
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
        return self.invoke(session, "set_value", {"value": value})

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
                normalized = _normalize_module(str(key))
                if normalized and normalized in STUDIO_MODULES and module_value is not None:
                    merged_modules[normalized] = module_value
        for key, module_value in module_map.items():
            if module_value is not None:
                merged_modules[key] = module_value

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            layout=layout,
            show_modules=show_modules,
            show_chrome=show_chrome,
            radius=radius,
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
        normalized = _normalize_module(module)
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
            props["module"] = _normalize_module(props.get("module"))
        if "state" in props:
            props["state"] = _normalize_state(props.get("state"))
        if "events" in props and isinstance(props.get("events"), Iterable):
            props["events"] = _normalize_events(props.get("events"))
        if "modules" in props and isinstance(props.get("modules"), Mapping):
            normalized_modules: dict[str, Any] = {}
            for key, value in dict(props["modules"]).items():
                normalized = _normalize_module(str(key))
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


TERMINAL_SCHEMA_VERSION = 2

TERMINAL_MODULES = {
    "capabilities",
    "command_builder",
    "flow_gate",
    "output_mapper",
    "presets",
    "progress",
    "progress_view",
    "prompt",
    "raw_view",
    "replay",
    "session",
    "stdin",
    "stdin_injector",
    "stream",
    "stream_view",
    "tabs",
    "timeline",
    "view",
    "workbench",
    "process_bridge",
    "execution_lane",
    "log_viewer",
    "log_panel",
}

TERMINAL_STATES = {"idle", "loading", "ready", "running", "paused", "disabled"}

TERMINAL_EVENTS = {
    "ready",
    "change",
    "submit",
    "input",
    "output",
    "state_change",
    "module_change",
}


class Terminal(Component):
    control_type = "terminal"

    def __init__(
        self,
        *,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        events: Iterable[str] | None = None,
        modules: Mapping[str, Any] | None = None,
        capabilities: Mapping[str, Any] | None = None,
        command_builder: Mapping[str, Any] | None = None,
        flow_gate: Mapping[str, Any] | None = None,
        output_mapper: Mapping[str, Any] | None = None,
        presets: Mapping[str, Any] | None = None,
        progress: Mapping[str, Any] | None = None,
        progress_view: Mapping[str, Any] | None = None,
        prompt: Mapping[str, Any] | None = None,
        raw_view: Mapping[str, Any] | None = None,
        replay: Mapping[str, Any] | None = None,
        session: Mapping[str, Any] | None = None,
        stdin: Mapping[str, Any] | None = None,
        stdin_injector: Mapping[str, Any] | None = None,
        stream: Mapping[str, Any] | None = None,
        stream_view: Mapping[str, Any] | None = None,
        tabs: Mapping[str, Any] | None = None,
        timeline: Mapping[str, Any] | None = None,
        view: Mapping[str, Any] | None = None,
        workbench: Mapping[str, Any] | None = None,
        process_bridge: Mapping[str, Any] | None = None,
        execution_lane: Mapping[str, Any] | None = None,
        log_viewer: Mapping[str, Any] | None = None,
        log_panel: Mapping[str, Any] | None = None,
        lines: list[Any] | None = None,
        output: str | None = None,
        raw_text: str | None = None,
        show_input: bool | None = None,
        read_only: bool | None = None,
        clear_on_submit: bool | None = None,
        strip_ansi: bool | None = None,
        auto_scroll: bool | None = None,
        wrap_lines: bool | None = None,
        max_lines: int | None = None,
        border_width: float | None = None,
        engine: str | None = None,
        webview_engine: str | None = None,
        schema_version: int = TERMINAL_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        module_map: dict[str, Any] = {
            "capabilities": capabilities,
            "command_builder": command_builder,
            "flow_gate": flow_gate,
            "output_mapper": output_mapper,
            "presets": presets,
            "progress": progress,
            "progress_view": progress_view,
            "prompt": prompt,
            "raw_view": raw_view,
            "replay": replay,
            "session": session,
            "stdin": stdin,
            "stdin_injector": stdin_injector,
            "stream": stream,
            "stream_view": stream_view,
            "tabs": tabs,
            "timeline": timeline,
            "view": view,
            "workbench": workbench,
            "process_bridge": process_bridge,
            "execution_lane": execution_lane,
            "log_viewer": log_viewer,
            "log_panel": log_panel,
        }

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, module_value in modules.items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in TERMINAL_MODULES and module_value is not None:
                    merged_modules[normalized] = module_value
        for key, module_value in module_map.items():
            if module_value is not None:
                merged_modules[key] = module_value

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            layout=layout,
            events=_normalize_events(events),
            modules=merged_modules,
            **merged_modules,
            lines=lines,
            output=output,
            raw_text=raw_text,
            show_input=show_input,
            read_only=read_only,
            clear_on_submit=clear_on_submit,
            strip_ansi=strip_ansi,
            auto_scroll=auto_scroll,
            wrap_lines=wrap_lines,
            max_lines=max_lines,
            border_width=border_width,
            engine=engine,
            webview_engine=webview_engine,
            **kwargs,
        )
        self._strict_contract = strict
        self._validate_props(merged, strict=strict)
        super().__init__(props=merged, style=style, strict=strict)

    @staticmethod
    def _validate_props(props: Mapping[str, Any], *, strict: bool) -> None:
        try:
            ensure_valid_props("terminal", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise ValueError("\n".join(exc.errors)) from exc

    def set_module(self, session: Any, module: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        normalized = _normalize_module(module)
        if normalized is None or normalized not in TERMINAL_MODULES:
            return {"ok": False, "error": f"Unknown terminal module '{module}'"}
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
        if normalized is None or normalized not in TERMINAL_STATES:
            return {"ok": False, "error": f"Unknown terminal state '{state}'"}
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
        if "events" in props and isinstance(props.get("events"), Iterable):
            props["events"] = _normalize_events(props.get("events"))
        if "modules" in props and isinstance(props.get("modules"), Mapping):
            normalized_modules: dict[str, Any] = {}
            for key, value in dict(props["modules"]).items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in TERMINAL_MODULES and value is not None:
                    normalized_modules[normalized] = value
            props["modules"] = normalized_modules
        next_props = dict(self.props)
        next_props.update({k: v for k, v in props.items() if v is not None})
        self._validate_props(next_props, strict=self._strict_contract)
        self.props.update({k: v for k, v in props.items() if v is not None})
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        event_name = _normalize_token(event)
        if event_name not in TERMINAL_EVENTS:
            return {"ok": False, "error": f"Unknown terminal event '{event}'"}
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

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def write(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "write", {"value": value})

    def append_lines(self, session: Any, lines: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "append_lines", {"lines": lines})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def set_input(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_input", {"value": value})

    def set_read_only(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_read_only", {"value": value})

    def get_buffer(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_buffer", {})


class OutputPanel(Component):
    control_type = "output_panel"

    def __init__(
        self,
        *,
        channels: Mapping[str, Any] | None = None,
        active_channel: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            channels=channels,
            active_channel=active_channel,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def append(self, session: Any, text: str, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"text": text}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "append", payload)

    def clear_channel(self, session: Any, channel: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if channel is not None:
            payload["channel"] = channel
        return self.invoke(session, "clear_channel", payload)

    def set_channel(self, session: Any, channel: str) -> dict[str, Any]:
        return self.invoke(session, "set_channel", {"channel": channel})

    def get_channel(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_channel", {})


class EditorTabStrip(Component):
    control_type = "editor_tab_strip"

    def __init__(
        self,
        *,
        tabs: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, tabs=tabs, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class WorkspaceTree(Component):
    control_type = "workspace_tree"

    def __init__(
        self,
        *,
        nodes: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, nodes=nodes, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class FileSystem(Component):
    control_type = "file_system"

    def __init__(
        self,
        *,
        root: str | None = None,
        nodes: list[dict[str, Any]] | None = None,
        selected_path: str | None = None,
        show_hidden: bool | None = None,
        readonly: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            root=root,
            nodes=nodes,
            selected_path=selected_path,
            show_hidden=show_hidden,
            readonly=readonly,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected_path(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected_path", {"path": path})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ProblemsPanel(Component):
    control_type = "problems_panel"

    def __init__(
        self,
        *,
        problems: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, problems=problems, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class EditorWorkspace(Component):
    control_type = "editor_workspace"

    def __init__(
        self,
        *,
        documents: list[dict[str, Any]] | None = None,
        active_id: str | None = None,
        workspace_nodes: list[dict[str, Any]] | None = None,
        problems: list[dict[str, Any]] | None = None,
        show_explorer: bool | None = None,
        show_problems: bool | None = None,
        show_status_bar: bool | None = None,
        status_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            documents=documents,
            active_id=active_id,
            workspace_nodes=workspace_nodes,
            problems=problems,
            show_explorer=show_explorer,
            show_problems=show_problems,
            show_status_bar=show_status_bar,
            status_text=status_text,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ChatThread(Component):
    control_type = "chat_thread"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        group_messages: bool | None = None,
        show_timestamps: bool | None = None,
        auto_scroll: bool | None = None,
        input_placeholder: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            group_messages=group_messages,
            show_timestamps=show_timestamps,
            auto_scroll=auto_scroll,
            input_placeholder=input_placeholder,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_messages(self, session: Any, messages: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_messages", {"messages": messages})

    def append_message(self, session: Any, message: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "append_message", {"message": dict(message)})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ChatMessage(Component):
    control_type = "chat_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        timestamp: str | None = None,
        status: str | None = None,
        avatar: str | None = None,
        align: str | None = None,
        grouped: bool | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            value=text,
            role=role,
            name=name,
            timestamp=timestamp,
            status=status,
            avatar=avatar,
            align=align,
            grouped=grouped,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Chat(ChatThread):
    control_type = "chat"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        group_messages: bool | None = None,
        show_timestamps: bool | None = None,
        auto_scroll: bool | None = None,
        input_placeholder: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            group_messages=group_messages,
            show_timestamps=show_timestamps,
            auto_scroll=auto_scroll,
            input_placeholder=input_placeholder,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class ChatBubble(ChatMessage):
    control_type = "chat_bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        timestamp: str | None = None,
        status: str | None = None,
        avatar: str | None = None,
        align: str | None = None,
        grouped: bool | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            text=text,
            role=role,
            name=name,
            timestamp=timestamp,
            status=status,
            avatar=avatar,
            align=align,
            grouped=grouped,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class MessageBubble(ChatMessage):
    control_type = "message_bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            text=text,
            role=role,
            name=name,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class MessageComposer(Component):
    control_type = "message_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class PromptComposer(MessageComposer):
    control_type = "prompt_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        prompt_label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            prompt_label=prompt_label,
            **kwargs,
        )
        Component.__init__(self, props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def attach(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "attach", {})


class Form(Component):
    control_type = "form"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        description: str | None = None,
        spacing: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            description=description,
            spacing=spacing,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class SubmitScope(Component):
    control_type = "submit_scope"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        enabled: bool | None = None,
        submit_on_enter: bool | None = None,
        submit_on_ctrl_enter: bool | None = None,
        debounce_ms: int | None = None,
        payload: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            submit_on_enter=submit_on_enter,
            submit_on_ctrl_enter=submit_on_ctrl_enter,
            debounce_ms=debounce_ms,
            payload=dict(payload) if payload is not None else None,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def submit(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "submit", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class AutoForm(Component):
    control_type = "auto_form"

    def __init__(
        self,
        *children: Any,
        schema: Mapping[str, Any] | None = None,
        fields: list[Mapping[str, Any]] | None = None,
        values: Mapping[str, Any] | None = None,
        title: str | None = None,
        description: str | None = None,
        submit_label: str | None = None,
        layout: str | None = None,
        columns: int | None = None,
        dense: bool | None = None,
        show_labels: bool | None = None,
        label_width: float | None = None,
        validation_rules: Mapping[str, Any] | None = None,
        visibility_rules: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            schema=schema,
            fields=fields,
            values=dict(values) if values is not None else None,
            title=title,
            description=description,
            submit_label=submit_label,
            layout=layout,
            columns=columns,
            dense=dense,
            show_labels=show_labels,
            label_width=label_width,
            validation_rules=dict(validation_rules) if validation_rules is not None else None,
            visibility_rules=dict(visibility_rules) if visibility_rules is not None else None,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def set_values(self, session: Any, values: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": dict(values)})

    def set_field_value(self, session: Any, field: str, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_field_value", {"field": field, "value": value})

    def validate(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "validate", {})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class FormField(Component):
    control_type = "form_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        label: str | None = None,
        description: str | None = None,
        required: bool | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            description=description,
            required=required,
            helper_text=helper_text,
            error_text=error_text,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class ValidationSummary(Component):
    control_type = "validation_summary"

    def __init__(
        self,
        *,
        title: str | None = None,
        errors: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, errors=errors, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)

