from __future__ import annotations

from pathlib import Path

from wire_umbrella_submodules_common import UmbrellaWireConfig, wire_umbrella

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
SKINS_DIR = PY_SRC / "butterflyui" / "controls" / "skins"
SUBMODULES_DIR = SKINS_DIR / "submodules"
ROOT_INIT_PATH = SKINS_DIR / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "skins"
    / "skins_registry.dart"
)

SKINS_MODULES = [
    "selector",
    "preset",
    "editor",
    "preview",
    "apply",
    "clear",
    "token_mapper",
    "create_skin",
    "edit_skin",
    "delete_skin",
    "effects",
    "particles",
    "shaders",
    "materials",
    "icons",
    "fonts",
    "colors",
    "background",
    "border",
    "shadow",
    "outline",
    "animation",
    "transition",
    "interaction",
    "layout",
    "responsive",
    "effect_editor",
    "particle_editor",
    "shader_editor",
    "material_editor",
    "icon_editor",
    "font_editor",
    "color_editor",
    "background_editor",
    "border_editor",
    "shadow_editor",
    "outline_editor",
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

SKIN_KEYS = {
    "skins",
    "selected_skin",
    "skin_id",
    "skin_name",
    "presets",
    "selected_preset",
    "preview_skin",
    "tokens",
    "token_overrides",
    "token_map",
    "palette",
    "theme",
}

VISUAL_KEYS = {
    "color",
    "bgcolor",
    "radius",
    "width",
    "height",
    "opacity",
    "intensity",
    "elevation",
    "blend_mode",
    "style",
}

LAYOUT_KEYS = {
    "spacing",
    "run_spacing",
    "alignment",
    "wrap",
    "columns",
    "rows",
    "density",
    "padding",
    "margin",
    "breakpoints",
    "responsive_mode",
}

ACTION_KEYS = {
    "action",
    "actions",
    "can_apply",
    "can_clear",
    "can_create",
    "can_edit",
    "can_delete",
    "confirm",
    "target",
    "status",
}

EDITOR_KEYS = {
    "value",
    "input",
    "query",
    "selection",
    "selection_ids",
    "active_tab",
    "tabs",
    "history",
    "undo_stack",
    "redo_stack",
    "dirty",
    "read_only",
}

PIPELINE_KEYS = {
    "pipeline",
    "pipelines",
    "provider",
    "providers",
    "distribution",
    "distributions",
    "editor",
    "preview",
    "command",
    "commands",
}

TOKEN_MODULES = {
    "token_mapper",
    "fonts",
    "colors",
    "background",
    "border",
    "shadow",
    "outline",
    "animation",
    "transition",
    "interaction",
    "layout",
    "responsive",
}

EDITOR_MODULES = {
    "editor",
    "effect_editor",
    "particle_editor",
    "shader_editor",
    "material_editor",
    "icon_editor",
    "font_editor",
    "color_editor",
    "background_editor",
    "border_editor",
    "shadow_editor",
    "outline_editor",
}

ACTION_MODULES = {"apply", "clear", "create_skin", "edit_skin", "delete_skin"}

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
    "skins": "list",
    "selected_skin": "string",
    "skin_id": "string",
    "skin_name": "string",
    "presets": "list",
    "selected_preset": "string",
    "preview_skin": "map",
    "tokens": "map",
    "token_overrides": "map",
    "token_map": "map",
    "palette": "map",
    "theme": "map",
    "color": "color",
    "bgcolor": "color",
    "radius": "num",
    "width": "dimension",
    "height": "dimension",
    "opacity": "num",
    "intensity": "num",
    "elevation": "num",
    "blend_mode": "string",
    "style": "map",
    "spacing": "num",
    "run_spacing": "num",
    "alignment": "alignment",
    "wrap": "bool",
    "columns": "int",
    "rows": "int",
    "density": "string",
    "padding": "padding",
    "margin": "padding",
    "breakpoints": "map",
    "responsive_mode": "string",
    "action": "string",
    "actions": "list",
    "can_apply": "bool",
    "can_clear": "bool",
    "can_create": "bool",
    "can_edit": "bool",
    "can_delete": "bool",
    "confirm": "bool",
    "target": "string",
    "status": "string",
    "value": "any",
    "input": "any",
    "query": "string",
    "selection": "map",
    "selection_ids": "list",
    "active_tab": "string",
    "tabs": "list",
    "history": "list",
    "undo_stack": "list",
    "redo_stack": "list",
    "dirty": "bool",
    "read_only": "bool",
    "pipeline": "string",
    "pipelines": "list",
    "provider": "string",
    "providers": "list",
    "distribution": "string",
    "distributions": "list",
    "editor": "string",
    "preview": "string",
    "command": "string",
    "commands": "list",
}


def _build_allowed_keys() -> dict[str, set[str]]:
    allowed = {token: set(COMMON_KEYS) for token in SKINS_MODULES}
    for token in SKINS_MODULES:
        allowed[token].update(SKIN_KEYS)
        allowed[token].update(VISUAL_KEYS)
    for token in TOKEN_MODULES:
        allowed[token].update({"tokens", "token_overrides", "token_map", "palette"})
    for token in EDITOR_MODULES:
        allowed[token].update(EDITOR_KEYS)
        allowed[token].update({"inspector", "sections", "active_section"})
    for token in ACTION_MODULES:
        allowed[token].update(ACTION_KEYS)
        allowed[token].update({"name", "skin_name", "selected_skin"})
    for token in {"selector", "preset", "preview"}:
        allowed[token].update({"selected_skin", "selected_preset", "skins", "presets", "query"})
    for token in {"layout", "responsive"}:
        allowed[token].update(LAYOUT_KEYS)
    for token in {"effects", "particles", "shaders", "materials", "icons", "fonts", "colors"}:
        allowed[token].update(PIPELINE_KEYS)
    return allowed


def _events_for_module(token: str) -> list[str]:
    events = {"change", "state_change", "module_change"}
    if token in {"selector", "preset", "preview"}:
        events.update({"select", "preview"})
    if token in ACTION_MODULES:
        events.add(token)
    if token == "token_mapper":
        events.add("token_map")
    if token in EDITOR_MODULES:
        events.update({"submit", "focus", "blur"})
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
        "register_pipeline",
        "register_editor",
        "register_preview",
        "register_distribution",
        "register_provider",
        "register_panel",
        "register_command",
    }
    if token in ACTION_MODULES:
        actions.add(token)
    if token == "token_mapper":
        actions.add("set_token_mapping")
    if token in EDITOR_MODULES:
        actions.update({"undo", "redo", "commit"})
    return sorted(actions)


def main() -> None:
    module_allowed_keys = _build_allowed_keys()
    module_payload_types = {
        token: {key: TYPE_HINTS.get(key, "any") for key in sorted(keys)}
        for token, keys in module_allowed_keys.items()
    }
    module_events = {token: _events_for_module(token) for token in SKINS_MODULES}
    module_actions = {token: _actions_for_module(token) for token in SKINS_MODULES}
    common_payload_types = {key: TYPE_HINTS.get(key, "any") for key in sorted(COMMON_KEYS)}

    cfg = UmbrellaWireConfig(
        umbrella="skins",
        umbrella_class="Skins",
        submodule_class="SkinsSubmodule",
        schema_version_const="SKINS_SCHEMA_VERSION",
        events_const="SKINS_EVENTS",
        states_const="SKINS_STATES",
        normalize_module_fn="_normalize_module",
        modules=list(SKINS_MODULES),
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
            "skins",
            "selected_skin",
            "presets",
            "value",
            "enabled",
        ),
        repo_root=REPO_ROOT,
        py_src=PY_SRC,
        submodules_dir=SUBMODULES_DIR,
        root_init_path=ROOT_INIT_PATH,
        dart_registry_path=DART_REGISTRY,
        dart_registry_var="skinsRegistryModules",
        root_schema_exports=(
            "SCHEMA_VERSION",
            "MODULES",
            "STATES",
            "EVENTS",
            "REGISTRY_ROLE_ALIASES",
            "REGISTRY_MANIFEST_LISTS",
            "DEFAULT_NAMES",
            "DEFAULT_PRESETS",
        ),
    )
    count = wire_umbrella(cfg)
    print(f"Wired Skins submodules: {count} modules")


if __name__ == "__main__":
    main()

