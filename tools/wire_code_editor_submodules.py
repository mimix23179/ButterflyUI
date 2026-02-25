from __future__ import annotations

import re
from pathlib import Path
from textwrap import dedent

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
SUBMODULES_DIR = PY_SRC / "butterflyui" / "controls" / "code_editor" / "submodules"
SCHEMA_PATH = SUBMODULES_DIR / "schema.py"
ROOT_INIT_PATH = PY_SRC / "butterflyui" / "controls" / "code_editor" / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "code_editor"
    / "code_editor_registry.dart"
)
SPECIAL_FILES = {"control.py", "schema.py", "components.py", "__init__.py", "family.py"}

CODE_EDITOR_MODULES = [
    "code_buffer",
    "code_category_layer",
    "code_document",
    "command_bar",
    "command_search",
    "diagnostic_stream",
    "diagnostics_panel",
    "diff",
    "diff_narrator",
    "dock",
    "dock_graph",
    "dock_pane",
    "document_tab_strip",
    "editor_intent_router",
    "editor_minimap",
    "editor_surface",
    "editor_tabs",
    "editor_view",
    "empty_state_view",
    "empty_view",
    "explorer_tree",
    "export_panel",
    "file_tabs",
    "file_tree",
    "ghost_editor",
    "gutter",
    "hint",
    "ide",
    "inline_error_view",
    "inline_search_overlay",
    "inline_widget",
    "inspector",
    "intent_panel",
    "intent_router",
    "intent_search",
    "mini_map",
    "query_token",
    "scope_picker",
    "scoped_search_replace",
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
    "semantic_search",
    "smart_search_bar",
    "tree",
    "workbench_editor",
    "workspace_explorer",
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

EDITOR_MODULES = {
    "ide",
    "editor_surface",
    "editor_view",
    "workbench_editor",
    "diff",
    "diff_narrator",
    "editor_minimap",
    "mini_map",
    "gutter",
    "hint",
    "inline_widget",
    "inline_error_view",
    "ghost_editor",
}
DOCUMENT_MODULES = {"code_buffer", "code_document", "code_category_layer"}
TAB_MODULES = {"editor_tabs", "document_tab_strip", "file_tabs"}
TREE_MODULES = {"workspace_explorer", "explorer_tree", "file_tree", "tree"}
SEARCH_MODULES = {
    "smart_search_bar",
    "search_box",
    "search_field",
    "search_history",
    "search_intent",
    "search_item",
    "search_provider",
    "search_results_view",
    "search_scope_selector",
    "search_source",
    "search_everything_panel",
    "semantic_search",
    "query_token",
    "scope_picker",
    "scoped_search_replace",
    "inline_search_overlay",
}
INTENT_MODULES = {
    "editor_intent_router",
    "intent_router",
    "intent_panel",
    "intent_search",
}
COMMAND_MODULES = {"command_bar", "command_search", "export_panel"}
DIAGNOSTIC_MODULES = {"diagnostic_stream", "diagnostics_panel"}
DOCK_MODULES = {"dock", "dock_pane", "dock_graph"}

EDITOR_KEYS = {
    "value",
    "text",
    "code",
    "language",
    "theme",
    "read_only",
    "word_wrap",
    "line_numbers",
    "show_gutter",
    "show_minimap",
    "glyph_margin",
    "font_size",
    "font_family",
    "tab_size",
    "document_uri",
    "engine",
    "webview_engine",
    "emit_on_change",
    "debounce_ms",
    "selection",
    "cursor",
    "scroll_top",
    "scroll_left",
}
DOCUMENT_KEYS = {
    "uri",
    "path",
    "name",
    "dirty",
    "version",
    "encoding",
    "content",
    "size",
    "mtime",
    "language",
    "read_only",
    "value",
    "text",
    "code",
}
TAB_KEYS = {
    "tabs",
    "active_tab",
    "pinned_tabs",
    "closable",
    "draggable",
    "reorderable",
    "show_icons",
    "show_dirty",
    "multi_select",
}
TREE_KEYS = {
    "nodes",
    "root",
    "selection",
    "expanded",
    "collapsed",
    "path",
    "show_hidden",
    "filter",
    "sort",
    "depth",
    "flatten",
}
SEARCH_KEYS = {
    "query",
    "results",
    "filters",
    "scope",
    "source",
    "provider",
    "history",
    "replace",
    "case_sensitive",
    "whole_word",
    "regex",
    "limit",
    "offset",
    "loading",
    "highlight",
    "tokens",
}
INTENT_KEYS = {
    "intent",
    "intents",
    "route",
    "routes",
    "resolver",
    "active_intent",
    "history",
    "confidence",
}
COMMAND_KEYS = {
    "commands",
    "command",
    "input",
    "history",
    "placeholder",
    "recent",
    "category",
    "shortcut",
    "enabled_commands",
}
DIAGNOSTIC_KEYS = {
    "items",
    "markers",
    "diagnostics",
    "severity",
    "counts",
    "summary",
    "range",
    "line",
    "column",
    "code",
    "message",
    "source",
}
DOCK_KEYS = {
    "panes",
    "layout",
    "active_pane",
    "orientation",
    "sizes",
    "floating",
    "pinned",
    "zone",
    "dock_id",
    "target",
}

MODULE_EXTRA_KEYS = {
    "diff": {"original", "modified", "inline", "context_lines"},
    "diff_narrator": {"summary", "chunks", "speak"},
    "mini_map": {"visible_lines", "viewport"},
    "editor_minimap": {"visible_lines", "viewport"},
    "gutter": {"breakpoints", "line_decorations"},
    "hint": {"hints", "active_hint"},
    "inline_widget": {"widget_id", "position", "content"},
    "inline_error_view": {"errors", "active_error"},
    "ghost_editor": {"ghost_text", "completions"},
    "export_panel": {"format", "target", "path", "include", "exclude", "progress", "status"},
    "inspector": {"selection", "properties", "sections", "target", "scope", "read_only"},
    "empty_state_view": {"message", "cta_label", "cta_action"},
    "empty_view": {"message", "cta_label", "cta_action"},
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
    "value": "string",
    "text": "string",
    "code": "string",
    "language": "string",
    "theme": "string",
    "read_only": "bool",
    "word_wrap": "bool",
    "line_numbers": "bool",
    "show_gutter": "bool",
    "show_minimap": "bool",
    "glyph_margin": "bool",
    "font_size": "num",
    "font_family": "string",
    "tab_size": "int",
    "document_uri": "string",
    "engine": "string",
    "webview_engine": "string",
    "emit_on_change": "bool",
    "debounce_ms": "int",
    "selection": "map",
    "cursor": "map",
    "scroll_top": "num",
    "scroll_left": "num",
    "uri": "string",
    "path": "string",
    "name": "string",
    "dirty": "bool",
    "version": "int",
    "encoding": "string",
    "content": "any",
    "size": "int",
    "mtime": "any",
    "tabs": "list",
    "active_tab": "any",
    "pinned_tabs": "list",
    "closable": "bool",
    "draggable": "bool",
    "reorderable": "bool",
    "show_icons": "bool",
    "show_dirty": "bool",
    "multi_select": "bool",
    "nodes": "list",
    "root": "any",
    "expanded": "list",
    "collapsed": "list",
    "show_hidden": "bool",
    "filter": "string",
    "sort": "string",
    "depth": "int",
    "flatten": "bool",
    "query": "string",
    "results": "list",
    "filters": "map",
    "scope": "string",
    "source": "string",
    "provider": "string",
    "history": "list",
    "replace": "string",
    "case_sensitive": "bool",
    "whole_word": "bool",
    "regex": "bool",
    "limit": "int",
    "offset": "int",
    "loading": "bool",
    "highlight": "bool",
    "tokens": "list",
    "intent": "string",
    "intents": "list",
    "route": "string",
    "routes": "list",
    "resolver": "map",
    "active_intent": "string",
    "confidence": "num",
    "commands": "list",
    "command": "string",
    "input": "string",
    "placeholder": "string",
    "recent": "list",
    "category": "string",
    "shortcut": "string",
    "enabled_commands": "list",
    "items": "list",
    "markers": "list",
    "diagnostics": "list",
    "severity": "string",
    "counts": "map",
    "summary": "string",
    "range": "map",
    "line": "int",
    "column": "int",
    "code": "string",
    "message": "string",
    "panes": "list",
    "layout": "map",
    "active_pane": "string",
    "orientation": "string",
    "sizes": "list",
    "floating": "bool",
    "pinned": "bool",
    "zone": "string",
    "dock_id": "string",
    "target": "string",
    "original": "string",
    "modified": "string",
    "inline": "bool",
    "context_lines": "int",
    "chunks": "list",
    "speak": "bool",
    "visible_lines": "list",
    "viewport": "map",
    "breakpoints": "list",
    "line_decorations": "list",
    "hints": "list",
    "active_hint": "any",
    "widget_id": "string",
    "position": "map",
    "errors": "list",
    "active_error": "any",
    "ghost_text": "string",
    "completions": "list",
    "format": "string",
    "include": "list",
    "exclude": "list",
    "progress": "num",
    "status": "string",
    "properties": "map",
    "sections": "list",
    "cta_label": "string",
    "cta_action": "string",
}

TYPE_TO_PY = {
    "any": "object",
    "bool": "bool",
    "string": "str",
    "num": "int | float",
    "int": "int",
    "map": "Mapping[str, object]",
    "list": "list[object]",
    "events": "Iterable[str]",
    "state": "str",
    "color": "str | int",
    "dimension": "int | float | str",
}


def _pascal(token: str) -> str:
    return "".join(part[:1].upper() + part[1:] for part in token.split("_") if part)


def _to_python_hint(type_name: str) -> str:
    return TYPE_TO_PY.get(type_name, "object")


def _render_set(values: set[str], indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for value in sorted(values):
        lines.append(f"{pad}    '{value}',")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_sets(values: dict[str, set[str]], indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': {{")
        for value in sorted(values[key]):
            lines.append(f"{pad}        '{value}',")
        lines.append(f"{pad}    }},")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_dict(values: dict[str, dict[str, str]], indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': {{")
        for sub_key in sorted(values[key]):
            lines.append(f"{pad}        '{sub_key}': '{values[key][sub_key]}',")
        lines.append(f"{pad}    }},")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_str(values: dict[str, str], indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': '{values[key]}',")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_lists(values: dict[str, list[str]], indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': [")
        for value in values[key]:
            lines.append(f"{pad}        '{value}',")
        lines.append(f"{pad}    ],")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _typed_params(keys: list[str], indent: str = "        ") -> str:
    if not keys:
        return ""
    return "\n".join(f"{indent}{key}: Any | None = None," for key in keys) + "\n"


def _payload_merge_lines(keys: list[str], indent: str = "        ") -> str:
    lines = [f"{indent}resolved_payload = dict(payload or {{}})"]
    for key in keys:
        lines.append(f"{indent}if {key} is not None:")
        lines.append(f"{indent}    resolved_payload[\"{key}\"] = {key}")
    return "\n".join(lines) + "\n"


def _build_allowed_keys() -> dict[str, set[str]]:
    allowed = {token: set(COMMON_KEYS) for token in CODE_EDITOR_MODULES}

    for token in EDITOR_MODULES:
        allowed[token].update(EDITOR_KEYS)
    for token in DOCUMENT_MODULES:
        allowed[token].update(DOCUMENT_KEYS)
    for token in TAB_MODULES:
        allowed[token].update(TAB_KEYS)
    for token in TREE_MODULES:
        allowed[token].update(TREE_KEYS)
    for token in SEARCH_MODULES:
        allowed[token].update(SEARCH_KEYS)
    for token in INTENT_MODULES:
        allowed[token].update(INTENT_KEYS)
    for token in COMMAND_MODULES:
        allowed[token].update(COMMAND_KEYS)
    for token in DIAGNOSTIC_MODULES:
        allowed[token].update(DIAGNOSTIC_KEYS)
    for token in DOCK_MODULES:
        allowed[token].update(DOCK_KEYS)

    for token, keys in MODULE_EXTRA_KEYS.items():
        allowed[token].update(keys)

    return allowed


def _events_for_module(token: str) -> list[str]:
    events = {"change", "module_change", "state_change"}
    if token in EDITOR_MODULES:
        events.update({"ready", "save", "submit", "format_request", "select", "cursor_change", "selection_change"})
    if token in {"code_buffer", "code_document", "editor_tabs", "document_tab_strip", "file_tabs"}:
        events.update({"open_document", "close_document", "select"})
    if token in TREE_MODULES:
        events.update({"select", "open_document", "expand", "collapse"})
    if token in SEARCH_MODULES:
        events.update({"search", "query_change", "result_select", "select"})
    if token in INTENT_MODULES:
        events.update({"intent_change", "select"})
    if token in COMMAND_MODULES:
        events.update({"command_execute", "submit", "select"})
    if token in DIAGNOSTIC_MODULES:
        events.update({"diagnostics_change", "select"})
    if token in DOCK_MODULES:
        events.update({"dock_change", "select"})
    if token in {"diff", "diff_narrator"}:
        events.update({"diff_change", "select"})
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
        "register_panel",
        "register_tool",
        "register_view",
        "register_surface",
        "register_provider",
        "register_command",
    }
    if token in EDITOR_MODULES | DOCUMENT_MODULES:
        actions.update({"set_value", "set_text", "set_code", "focus", "blur", "select_all", "insert_text", "format_document", "reveal_line", "set_markers"})
    if token in SEARCH_MODULES:
        actions.update({"search", "clear_search"})
    if token in TAB_MODULES:
        actions.update({"open_tab", "close_tab", "select_tab"})
    if token in TREE_MODULES:
        actions.update({"expand", "collapse", "reveal"})
    if token in DOCK_MODULES:
        actions.update({"dock", "undock", "split", "activate_pane"})
    if token in COMMAND_MODULES:
        actions.update({"run_command", "open_palette"})
    if token in INTENT_MODULES:
        actions.update({"route_intent", "resolve_intent"})
    if token in DIAGNOSTIC_MODULES:
        actions.update({"publish_diagnostics"})
    if token == "export_panel":
        actions.update({"export"})
    return sorted(actions)


def _module_text(
    module: str,
    class_name: str,
    module_keys: list[str],
    module_key_types: dict[str, str],
) -> str:
    lines = [
        "from __future__ import annotations",
        "",
        "from collections.abc import Mapping",
        "from typing import Iterable",
        "",
        "from .control import CodeEditorSubmodule",
        "from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES",
        "",
        f'MODULE_TOKEN = "{module}"',
        "",
        "",
        f"class {class_name}(CodeEditorSubmodule):",
        f'    """CodeEditor submodule host control for `{module}`."""',
        "",
        f'    control_type = "code_editor_{module}"',
        '    umbrella = "code_editor"',
        "    module_token = MODULE_TOKEN",
        "    canonical_module = MODULE_TOKEN",
        "",
        "    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))",
        "    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))",
        "    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))",
        "    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))",
        "",
        "    def __init__(",
        "        self,",
        "        payload: Mapping[str, object] | None = None,",
        "        props: Mapping[str, object] | None = None,",
        "        style: Mapping[str, object] | None = None,",
        "        strict: bool = False,",
    ]
    for key in module_keys:
        hint = _to_python_hint(str(module_key_types.get(key, "any")))
        lines.append(f"        {key}: {hint} | None = None,")
    lines.extend(
        [
            "        **kwargs: object,",
            "    ) -> None:",
            "        resolved_payload = dict(payload or {})",
        ]
    )
    for key in module_keys:
        lines.append(f"        if {key} is not None:")
        lines.append(f'            resolved_payload["{key}"] = {key}')
    lines.extend(
        [
            "        super().__init__(",
            "            payload=resolved_payload,",
            "            props=props,",
            "            style=style,",
            "            strict=strict,",
            "            **kwargs,",
            "        )",
            "",
            "    def set_module_props(self, session: object, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        update_payload = dict(payload or {})",
            "        if kwargs:",
            "            update_payload.update(kwargs)",
            "        return self.set_payload(session, update_payload)",
            "",
            "    def emit_module_event(self, session: object, event: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        return self.emit_event(session, event, payload, **kwargs)",
            "",
            "    def run_module_action(self, session: object, action: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:",
            "        return self.run_action(session, action, payload, **kwargs)",
            "",
            "    def contract(self) -> dict[str, object]:",
            "        return self.describe_contract()",
            "",
            "",
            f'__all__ = ["{class_name}"]',
        ]
    )
    return "\n".join(lines) + "\n"


def _components_text(modules: list[str], class_names: dict[str, str]) -> str:
    imports = "\n".join(f"from .{module} import {class_names[module]}" for module in modules)
    mapping = "\n".join(f'    "{module}": {class_names[module]},' for module in modules)
    exports = "\n".join(f'    "{class_names[module]}",' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        f"{imports}\n\n"
        "MODULE_COMPONENTS = {\n"
        f"{mapping}\n"
        "}\n\n"
        "globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})\n\n"
        "__all__ = [\n"
        '    "MODULE_COMPONENTS",\n'
        f"{exports}\n"
        "]\n"
    )


def _init_text() -> str:
    return dedent(
        """
        from __future__ import annotations

        from .components import MODULE_COMPONENTS
        from .components import __all__ as _component_all
        from .components import *
        from .schema import CONTROL_PREFIX, MODULE_CANONICAL, MODULE_CLASS_NAMES, MODULE_TOKENS, SUPPORTED_EVENTS

        __all__ = [
            "CONTROL_PREFIX",
            "MODULE_TOKENS",
            "MODULE_CANONICAL",
            "SUPPORTED_EVENTS",
            "MODULE_CLASS_NAMES",
            "MODULE_COMPONENTS",
            *_component_all,
        ]
        """
    ).strip() + "\n"


def _family_text() -> str:
    return dedent(
        """
        from __future__ import annotations

        from .components import MODULE_COMPONENTS
        from .components import __all__ as _component_all
        from .components import *

        __all__ = ["MODULE_COMPONENTS", *_component_all]
        """
    ).strip() + "\n"


def _root_init_text(modules: list[str], class_names: dict[str, str]) -> str:
    class_imports = ",\n    ".join(class_names[module] for module in modules)
    bind_lines: list[str] = []
    for module in modules:
        cls = class_names[module]
        bind_lines.append(f"CodeEditor.{module}: type[{cls}] = {cls}")
        bind_lines.append(f"CodeEditor.{cls}: type[{cls}] = {cls}")
    module_exports = ",\n    ".join(f'"{class_names[module]}"' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .control import CodeEditor\n"
        "from .submodules import (\n"
        f"    {class_imports},\n"
        ")\n"
        "from .schema import (\n"
        "    DEFAULT_ENGINE,\n"
        "    DEFAULT_WEBVIEW_ENGINE,\n"
        "    EVENTS,\n"
        "    MODULES,\n"
        "    REGISTRY_MANIFEST_LISTS,\n"
        "    REGISTRY_ROLE_ALIASES,\n"
        "    SCHEMA_VERSION,\n"
        "    STATES,\n"
        ")\n\n"
        f"{chr(10).join(bind_lines)}\n\n"
        "__all__ = [\n"
        '    "CodeEditor",\n'
        '    "SCHEMA_VERSION",\n'
        '    "DEFAULT_ENGINE",\n'
        '    "DEFAULT_WEBVIEW_ENGINE",\n'
        '    "MODULES",\n'
        '    "STATES",\n'
        '    "EVENTS",\n'
        '    "REGISTRY_ROLE_ALIASES",\n'
        '    "REGISTRY_MANIFEST_LISTS",\n'
        '    "MODULE_COMPONENTS",\n'
        f"    {module_exports},\n"
        "]\n"
    )


def _schema_text(
    modules: list[str],
    class_names: dict[str, str],
    allowed: dict[str, set[str]],
    events: dict[str, list[str]],
    actions: dict[str, list[str]],
) -> str:
    common_types = {key: TYPE_HINTS.get(key, "any") for key in sorted(COMMON_KEYS)}
    module_types = {token: {key: TYPE_HINTS.get(key, "any") for key in sorted(keys)} for token, keys in allowed.items()}
    lines = [
        "from __future__ import annotations",
        "",
        "from ..schema import EVENTS as UMBRELLA_EVENTS",
        "from ..schema import MODULES as UMBRELLA_MODULES",
        "",
        'CONTROL_PREFIX = "code_editor"',
        "",
        "MODULE_TOKENS = tuple(str(module) for module in UMBRELLA_MODULES)",
        "MODULE_CANONICAL = MODULE_TOKENS",
        "SUPPORTED_EVENTS = tuple(str(event) for event in UMBRELLA_EVENTS)",
        "",
        f"MODULE_CLASS_NAMES = {_render_dict_of_str(class_names)}",
        "",
        f"CODE_EDITOR_COMMON_PAYLOAD_KEYS = {_render_set(COMMON_KEYS)}",
        "",
        f"CODE_EDITOR_COMMON_PAYLOAD_TYPES = {_render_dict_of_str(common_types)}",
        "",
        f"MODULE_ALLOWED_KEYS = {_render_dict_of_sets(allowed)}",
        "",
        f"MODULE_PAYLOAD_TYPES = {_render_dict_of_dict(module_types)}",
        "",
        f"MODULE_EVENTS = {_render_dict_of_lists(events)}",
        "",
        f"MODULE_ACTIONS = {_render_dict_of_lists(actions)}",
        "",
        "__all__ = [",
        '    "CONTROL_PREFIX",',
        '    "MODULE_TOKENS",',
        '    "MODULE_CANONICAL",',
        '    "SUPPORTED_EVENTS",',
        '    "MODULE_CLASS_NAMES",',
        '    "CODE_EDITOR_COMMON_PAYLOAD_KEYS",',
        '    "CODE_EDITOR_COMMON_PAYLOAD_TYPES",',
        '    "MODULE_ALLOWED_KEYS",',
        '    "MODULE_PAYLOAD_TYPES",',
        '    "MODULE_EVENTS",',
        '    "MODULE_ACTIONS",',
        "]",
    ]
    return "\n".join(lines) + "\n"


def _parse_dart_registry_modules(path: Path, variable_name: str) -> set[str]:
    text = path.read_text(encoding="utf-8")
    pattern = rf"{re.escape(variable_name)}\s*=\s*\{{(.*?)\}};"
    match = re.search(pattern, text, re.S)
    if not match:
        raise RuntimeError(f"Could not parse Dart registry set: {variable_name}")
    return set(re.findall(r"'([a-z0-9_]+)'", match.group(1)))


def main() -> None:
    modules = list(CODE_EDITOR_MODULES)
    class_names = {module: _pascal(module) for module in modules}
    allowed = _build_allowed_keys()
    events = {module: _events_for_module(module) for module in modules}
    actions = {module: _actions_for_module(module) for module in modules}
    module_types = {
        token: {key: TYPE_HINTS.get(key, "any") for key in sorted(keys)}
        for token, keys in allowed.items()
    }

    SUBMODULES_DIR.mkdir(parents=True, exist_ok=True)

    SCHEMA_PATH.write_text(_schema_text(modules, class_names, allowed, events, actions), encoding="utf-8")

    for file_path in SUBMODULES_DIR.glob("*.py"):
        if file_path.name in SPECIAL_FILES:
            continue
        if file_path.stem not in modules:
            file_path.unlink()

    for module in modules:
        class_name = class_names[module]
        module_keys = sorted(allowed.get(module, set()) - COMMON_KEYS)
        module_path = SUBMODULES_DIR / f"{module}.py"
        module_path.write_text(
            _module_text(module, class_name, module_keys, module_types.get(module, {})),
            encoding="utf-8",
        )

    (SUBMODULES_DIR / "components.py").write_text(_components_text(modules, class_names), encoding="utf-8")
    (SUBMODULES_DIR / "__init__.py").write_text(_init_text(), encoding="utf-8")
    (SUBMODULES_DIR / "family.py").write_text(_family_text(), encoding="utf-8")
    ROOT_INIT_PATH.write_text(_root_init_text(modules, class_names), encoding="utf-8")

    dart_modules = _parse_dart_registry_modules(DART_REGISTRY, "codeEditorRegistryModules")
    py_modules = set(modules)
    missing_in_dart = sorted(py_modules - dart_modules)
    missing_in_py = sorted(dart_modules - py_modules)
    if missing_in_dart or missing_in_py:
        raise RuntimeError(
            "CodeEditor Python/Dart registry mismatch: "
            f"missing_in_dart={missing_in_dart}, missing_in_py={missing_in_py}"
        )

    print(f"Wired CodeEditor submodules: {len(modules)} modules")


if __name__ == "__main__":
    main()
