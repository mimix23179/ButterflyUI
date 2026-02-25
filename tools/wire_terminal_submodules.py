from __future__ import annotations

from pathlib import Path

from wire_umbrella_submodules_common import UmbrellaWireConfig, wire_umbrella

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
TERMINAL_DIR = PY_SRC / "butterflyui" / "controls" / "terminal"
SUBMODULES_DIR = TERMINAL_DIR / "submodules"
ROOT_INIT_PATH = TERMINAL_DIR / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "terminal"
    / "terminal_registry.dart"
)

TERMINAL_MODULES = [
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
]

COMMON_KEYS = {
    "enabled",
    "visible",
    "variant",
    "state",
    "title",
    "subtitle",
    "label",
    "description",
    "icon",
    "events",
    "tags",
    "meta",
    "payload",
    "options",
    "context",
    "telemetry",
}

TERMINAL_KEYS = {
    "lines",
    "output",
    "raw_text",
    "input",
    "command",
    "commands",
    "history",
    "cwd",
    "env",
    "status",
    "exit_code",
    "engine",
    "webview_engine",
}

VIEW_KEYS = {
    "show_input",
    "read_only",
    "clear_on_submit",
    "strip_ansi",
    "auto_scroll",
    "wrap_lines",
    "max_lines",
    "border_width",
    "font_family",
    "font_size",
    "line_height",
}

PROGRESS_KEYS = {
    "progress",
    "total",
    "value",
    "indeterminate",
    "stage",
    "percent",
    "eta",
    "throughput",
}

PIPELINE_KEYS = {
    "providers",
    "backend",
    "bridge",
    "presets",
    "capabilities",
    "mapping",
    "lane",
    "session_id",
}

TYPE_HINTS = {
    "enabled": "bool",
    "visible": "bool",
    "variant": "string",
    "state": "state",
    "title": "string",
    "subtitle": "string",
    "label": "string",
    "description": "string",
    "icon": "string",
    "events": "events",
    "tags": "list",
    "meta": "map",
    "payload": "map",
    "options": "list",
    "context": "map",
    "telemetry": "map",
    "lines": "list",
    "output": "string",
    "raw_text": "string",
    "input": "string",
    "command": "string",
    "commands": "list",
    "history": "list",
    "cwd": "string",
    "env": "map",
    "status": "string",
    "exit_code": "int",
    "engine": "string",
    "webview_engine": "string",
    "show_input": "bool",
    "read_only": "bool",
    "clear_on_submit": "bool",
    "strip_ansi": "bool",
    "auto_scroll": "bool",
    "wrap_lines": "bool",
    "max_lines": "int",
    "border_width": "num",
    "font_family": "string",
    "font_size": "num",
    "line_height": "num",
    "progress": "num",
    "total": "num",
    "value": "any",
    "indeterminate": "bool",
    "stage": "string",
    "percent": "num",
    "eta": "string",
    "throughput": "string",
    "providers": "list",
    "backend": "string",
    "bridge": "string",
    "presets": "list",
    "capabilities": "map",
    "mapping": "map",
    "lane": "string",
    "session_id": "string",
}


def _build_allowed_keys() -> dict[str, set[str]]:
    allowed = {token: set(COMMON_KEYS) for token in TERMINAL_MODULES}
    for token in TERMINAL_MODULES:
        allowed[token].update(TERMINAL_KEYS)
        allowed[token].update(VIEW_KEYS)
    for token in {"progress", "progress_view", "timeline"}:
        allowed[token].update(PROGRESS_KEYS)
    for token in {"capabilities", "process_bridge", "execution_lane", "output_mapper", "flow_gate", "command_builder"}:
        allowed[token].update(PIPELINE_KEYS)
    for token in {"stdin", "stdin_injector", "prompt"}:
        allowed[token].update({"input", "placeholder", "submit_label"})
    for token in {"stream", "stream_view", "raw_view", "log_viewer", "log_panel", "view"}:
        allowed[token].update({"lines", "output", "raw_text", "filters"})
    return allowed


def _events_for_module(token: str) -> list[str]:
    events = {"ready", "change", "submit", "input", "output", "state_change", "module_change"}
    if token in {"progress", "progress_view", "timeline"}:
        events.add("progress")
    if token in {"stdin", "stdin_injector", "prompt", "command_builder"}:
        events.add("command")
    if token in {"stream", "stream_view", "raw_view", "log_viewer", "log_panel", "view"}:
        events.add("stream")
    return sorted(events)


def _actions_for_module(token: str) -> list[str]:
    actions = {
        "set_payload",
        "set_props",
        "set_module",
        "set_state",
        "get_state",
        "emit",
        "trigger",
        "activate",
        "emit_change",
        "register_module",
        "register_view",
        "register_panel",
        "register_tool",
        "register_provider",
        "register_backend",
        "register_bridge",
        "register_command",
        "write",
        "append",
        "append_lines",
        "clear",
        "focus",
        "blur",
        "set_input",
        "set_value",
        "get_input",
        "set_read_only",
        "submit",
        "get_buffer",
        "get_value",
    }
    if token in {"progress", "progress_view"}:
        actions.update({"set_progress", "set_total"})
    return sorted(actions)


def main() -> None:
    module_allowed_keys = _build_allowed_keys()
    module_payload_types = {
        token: {key: TYPE_HINTS.get(key, "any") for key in sorted(keys)}
        for token, keys in module_allowed_keys.items()
    }
    module_events = {token: _events_for_module(token) for token in TERMINAL_MODULES}
    module_actions = {token: _actions_for_module(token) for token in TERMINAL_MODULES}
    common_payload_types = {key: TYPE_HINTS.get(key, "any") for key in sorted(COMMON_KEYS)}

    cfg = UmbrellaWireConfig(
        umbrella="terminal",
        umbrella_class="Terminal",
        submodule_class="TerminalSubmodule",
        schema_version_const="TERMINAL_SCHEMA_VERSION",
        events_const="TERMINAL_EVENTS",
        states_const="TERMINAL_STATES",
        normalize_module_fn="_normalize_module",
        modules=list(TERMINAL_MODULES),
        common_payload_keys=set(COMMON_KEYS),
        common_payload_types=common_payload_types,
        module_allowed_keys=module_allowed_keys,
        module_payload_types=module_payload_types,
        module_events=module_events,
        module_actions=module_actions,
        base_props=(
            "schema_version",
            "module",
            "module_id",
            "state",
            "custom_layout",
            "layout",
            "events",
            "manifest",
            "registries",
            "modules",
            "lines",
            "output",
            "raw_text",
            "show_input",
            "read_only",
            "clear_on_submit",
            "strip_ansi",
            "auto_scroll",
            "wrap_lines",
            "max_lines",
            "border_width",
            "engine",
            "webview_engine",
        ),
        repo_root=REPO_ROOT,
        py_src=PY_SRC,
        submodules_dir=SUBMODULES_DIR,
        root_init_path=ROOT_INIT_PATH,
        dart_registry_path=DART_REGISTRY,
        dart_registry_var="terminalRegistryModules",
        root_schema_exports=(
            "SCHEMA_VERSION",
            "DEFAULT_ENGINE",
            "MODULES",
            "STATES",
            "EVENTS",
            "REGISTRY_ROLE_ALIASES",
            "REGISTRY_MANIFEST_LISTS",
        ),
    )
    count = wire_umbrella(cfg)
    print(f"Wired Terminal submodules: {count} modules")


if __name__ == "__main__":
    main()

