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
    _normalize_token,
    _register_runtime_module,
)

__all__ = [
    "TERMINAL_SCHEMA_VERSION",
    "TERMINAL_DEFAULT_ENGINE",
    "TERMINAL_MODULES",
    "TERMINAL_STATES",
    "TERMINAL_EVENTS",
    "TERMINAL_REGISTRY_ROLE_ALIASES",
    "TERMINAL_REGISTRY_MANIFEST_LISTS",
    "Terminal",
]

TERMINAL_SCHEMA_VERSION = 2
TERMINAL_DEFAULT_ENGINE = "xterm"

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

TERMINAL_REGISTRY_ROLE_ALIASES = {
    "module": "module_registry",
    "modules": "module_registry",
    "view": "view_registry",
    "views": "view_registry",
    "panel": "panel_registry",
    "panels": "panel_registry",
    "tool": "tool_registry",
    "tools": "tool_registry",
    "provider": "provider_registry",
    "providers": "provider_registry",
    "backend": "provider_registry",
    "backends": "provider_registry",
    "bridge": "provider_registry",
    "bridges": "provider_registry",
    "command": "command_registry",
    "commands": "command_registry",
    "module_registry": "module_registry",
    "view_registry": "view_registry",
    "panel_registry": "panel_registry",
    "tool_registry": "tool_registry",
    "provider_registry": "provider_registry",
    "command_registry": "command_registry",
}

TERMINAL_REGISTRY_MANIFEST_LISTS = {
    "module_registry": "enabled_modules",
    "view_registry": "enabled_views",
    "panel_registry": "enabled_panels",
    "tool_registry": "enabled_tools",
    "provider_registry": "enabled_providers",
    "command_registry": "enabled_commands",
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

        normalized_engine = _normalize_engine(engine, fallback=TERMINAL_DEFAULT_ENGINE)
        normalized_webview_engine = _normalize_engine(webview_engine)

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
            engine=normalized_engine,
            webview_engine=normalized_webview_engine,
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
        if "engine" in props:
            props["engine"] = _normalize_engine(
                props.get("engine"),
                fallback=str(self.props.get("engine") or TERMINAL_DEFAULT_ENGINE),
            )
        if "webview_engine" in props:
            props["webview_engine"] = _normalize_engine(props.get("webview_engine"))
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
            role_aliases=TERMINAL_REGISTRY_ROLE_ALIASES,
            role_manifest_lists=TERMINAL_REGISTRY_MANIFEST_LISTS,
            allowed_modules=TERMINAL_MODULES,
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

    def register_backend(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="backend",
            module_id=module_id,
            definition=definition,
        )

    def register_bridge(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="bridge",
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
        self.props["lines"] = []
        self.props["output"] = ""
        self.props["raw_text"] = ""
        return self.invoke(session, "clear", {})

    def write(self, session: Any, value: str) -> dict[str, Any]:
        text_value = str(value)
        current_output = str(self.props.get("output") or "")
        self.props["output"] = f"{current_output}{text_value}"
        return self.invoke(session, "write", {"value": text_value})

    def append(self, session: Any, value: str) -> dict[str, Any]:
        text_value = str(value)
        current_output = str(self.props.get("output") or "")
        self.props["output"] = f"{current_output}{text_value}"
        return self.invoke(session, "append", {"value": text_value})

    def append_lines(self, session: Any, lines: list[Any]) -> dict[str, Any]:
        existing = list(self.props.get("lines") or [])
        existing.extend(lines)
        self.props["lines"] = existing
        return self.invoke(session, "append_lines", {"lines": lines})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def set_input(self, session: Any, value: str) -> dict[str, Any]:
        text_value = str(value)
        self.props["input"] = text_value
        return self.invoke(session, "set_input", {"value": text_value})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        text_value = str(value)
        self.props["input"] = text_value
        return self.invoke(session, "set_value", {"value": text_value})

    def get_input(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_input", {})

    def set_read_only(self, session: Any, value: bool) -> dict[str, Any]:
        self.props["read_only"] = bool(value)
        return self.invoke(session, "set_read_only", {"value": bool(value)})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def get_buffer(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_buffer", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
