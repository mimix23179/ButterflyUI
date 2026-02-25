from __future__ import annotations

from pathlib import Path

from wire_umbrella_submodules_common import UmbrellaWireConfig, wire_umbrella

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
STUDIO_DIR = PY_SRC / "butterflyui" / "controls" / "studio"
SUBMODULES_DIR = STUDIO_DIR / "submodules"
ROOT_INIT_PATH = STUDIO_DIR / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "studio"
    / "studio_registry.dart"
)

STUDIO_MODULES = [
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

WORKBENCH_KEYS = {
    "show_modules",
    "show_chrome",
    "layout",
    "custom_layout",
    "radius",
    "left_pane_ratio",
    "right_pane_ratio",
    "bottom_panel_height",
    "documents",
    "assets",
    "active_document",
    "active_surface",
    "focused_panel",
}

SURFACE_KEYS = {
    "surface",
    "surface_id",
    "scene",
    "viewport",
    "zoom",
    "pan",
    "snap",
    "grid",
    "background",
}

PANEL_KEYS = {
    "panels",
    "panel",
    "panel_id",
    "collapsed",
    "pinned",
    "dock",
    "items",
    "selection",
}

TOOL_KEYS = {
    "tool",
    "tools",
    "active_tool",
    "tool_options",
    "selected_id",
    "selected_ids",
    "selection_mode",
    "transform",
    "bounds",
}

EDITOR_KEYS = {
    "value",
    "input",
    "query",
    "history",
    "undo_stack",
    "redo_stack",
    "read_only",
    "dirty",
    "schema",
    "bindings",
    "tokens",
    "actions",
}

REGISTRY_KEYS = {
    "manifest",
    "registries",
    "modules",
    "surface_registry",
    "tool_registry",
    "panel_registry",
    "importer_registry",
    "exporter_registry",
    "schema_registry",
    "command_registry",
}

SURFACE_MODULES = {"builder", "canvas", "canvas_surface", "timeline_surface", "node_surface", "preview_surface", "node_graph", "timeline", "timeline_editor", "preview", "transform"}
PANEL_MODULES = {"block_palette", "component_palette", "inspector", "outline_tree", "project_panel", "properties_panel", "responsive_toolbar", "assets_panel", "layers_panel", "properties", "assets", "layers"}
TOOL_MODULES = {"selection_tools", "transform_box", "transform_toolbar", "toolbox", "transform_tools", "responsive"}
EDITOR_MODULES = {"tokens_editor", "actions_editor", "bindings_editor", "asset_browser", "token_editor", "tokens", "node"}

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
    "show_modules": "bool",
    "show_chrome": "bool",
    "layout": "string",
    "custom_layout": "bool",
    "radius": "num",
    "left_pane_ratio": "num",
    "right_pane_ratio": "num",
    "bottom_panel_height": "num",
    "documents": "list",
    "assets": "list",
    "active_document": "string",
    "active_surface": "string",
    "focused_panel": "string",
    "surface": "string",
    "surface_id": "string",
    "scene": "map",
    "viewport": "map",
    "zoom": "num",
    "pan": "map",
    "snap": "bool",
    "grid": "map",
    "background": "map",
    "panels": "map",
    "panel": "string",
    "panel_id": "string",
    "collapsed": "bool",
    "pinned": "bool",
    "dock": "map",
    "items": "list",
    "selection": "map",
    "tool": "string",
    "tools": "list",
    "active_tool": "string",
    "tool_options": "map",
    "selected_id": "string",
    "selected_ids": "list",
    "selection_mode": "string",
    "transform": "map",
    "bounds": "map",
    "value": "any",
    "input": "any",
    "query": "string",
    "history": "list",
    "undo_stack": "list",
    "redo_stack": "list",
    "read_only": "bool",
    "dirty": "bool",
    "schema": "map",
    "bindings": "map",
    "tokens": "map",
    "actions": "list",
    "manifest": "map",
    "registries": "map",
    "modules": "map",
    "surface_registry": "map",
    "tool_registry": "map",
    "panel_registry": "map",
    "importer_registry": "map",
    "exporter_registry": "map",
    "schema_registry": "map",
    "command_registry": "map",
}


def _build_allowed_keys() -> dict[str, set[str]]:
    allowed = {token: set(COMMON_KEYS) for token in STUDIO_MODULES}
    for token in STUDIO_MODULES:
        allowed[token].update(WORKBENCH_KEYS)
        allowed[token].update(REGISTRY_KEYS)
    for token in SURFACE_MODULES:
        allowed[token].update(SURFACE_KEYS)
    for token in PANEL_MODULES:
        allowed[token].update(PANEL_KEYS)
    for token in TOOL_MODULES:
        allowed[token].update(TOOL_KEYS)
    for token in EDITOR_MODULES:
        allowed[token].update(EDITOR_KEYS)
    return allowed


def _events_for_module(token: str) -> list[str]:
    events = {"ready", "change", "submit", "select", "state_change", "module_change"}
    if token in SURFACE_MODULES:
        events.update({"surface_change", "viewport_change"})
    if token in PANEL_MODULES:
        events.update({"panel_change", "focus"})
    if token in TOOL_MODULES:
        events.update({"tool_change", "selection_change"})
    if token in EDITOR_MODULES:
        events.update({"input", "commit"})
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
        "register_surface",
        "register_tool",
        "register_panel",
        "register_importer",
        "register_exporter",
        "register_command",
        "register_schema",
        "set_selection",
        "set_tool",
        "activate_tool",
        "set_active_surface",
        "focus_panel",
    }
    if token in EDITOR_MODULES:
        actions.update({"undo", "redo", "commit"})
    if token in SURFACE_MODULES:
        actions.update({"zoom_in", "zoom_out", "fit_to_view"})
    return sorted(actions)


def main() -> None:
    module_allowed_keys = _build_allowed_keys()
    module_payload_types = {
        token: {key: TYPE_HINTS.get(key, "any") for key in sorted(keys)}
        for token, keys in module_allowed_keys.items()
    }
    module_events = {token: _events_for_module(token) for token in STUDIO_MODULES}
    module_actions = {token: _actions_for_module(token) for token in STUDIO_MODULES}
    common_payload_types = {key: TYPE_HINTS.get(key, "any") for key in sorted(COMMON_KEYS)}

    cfg = UmbrellaWireConfig(
        umbrella="studio",
        umbrella_class="Studio",
        submodule_class="StudioSubmodule",
        schema_version_const="STUDIO_SCHEMA_VERSION",
        events_const="STUDIO_EVENTS",
        states_const="STUDIO_STATES",
        normalize_module_fn="_normalize_studio_module",
        modules=list(STUDIO_MODULES),
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
            "show_modules",
            "show_chrome",
            "radius",
            "events",
            "manifest",
            "registries",
            "modules",
            "panels",
            "shortcuts",
            "render",
            "cache",
            "media",
            "documents",
            "assets",
            "left_pane_ratio",
            "right_pane_ratio",
            "bottom_panel_height",
        ),
        repo_root=REPO_ROOT,
        py_src=PY_SRC,
        submodules_dir=SUBMODULES_DIR,
        root_init_path=ROOT_INIT_PATH,
        dart_registry_path=DART_REGISTRY,
        dart_registry_var="studioRegistryModules",
        root_schema_exports=(
            "SCHEMA_VERSION",
            "MODULES",
            "STATES",
            "EVENTS",
            "REGISTRY_ROLE_ALIASES",
            "REGISTRY_MANIFEST_LISTS",
        ),
    )
    count = wire_umbrella(cfg)
    print(f"Wired Studio submodules: {count} modules")


if __name__ == "__main__":
    main()

