from __future__ import annotations

import re
from pathlib import Path
from textwrap import dedent

REPO_ROOT = Path(__file__).resolve().parents[1]
PY_SRC = REPO_ROOT / "butterflyui" / "sdk" / "python" / "packages" / "butterflyui" / "src"
GALLERY_DIR = PY_SRC / "butterflyui" / "controls" / "gallery"
SUBMODULES_DIR = GALLERY_DIR / "submodules"
SCHEMA_PATH = SUBMODULES_DIR / "schema.py"
CONTROL_PATH = SUBMODULES_DIR / "control.py"
ROOT_INIT_PATH = GALLERY_DIR / "__init__.py"
DART_REGISTRY = (
    REPO_ROOT
    / "butterflyui"
    / "src"
    / "lib"
    / "src"
    / "core"
    / "controls"
    / "gallery"
    / "gallery_registry.dart"
)
SPECIAL_FILES = {"control.py", "schema.py", "components.py", "__init__.py", "family.py"}

GALLERY_MODULES = [
    "toolbar",
    "filter_bar",
    "grid_layout",
    "item_actions",
    "item_badge",
    "item_meta_row",
    "item_preview",
    "item_selectable",
    "item_tile",
    "pagination",
    "section_header",
    "sort_bar",
    "empty_state",
    "loading_skeleton",
    "search_bar",
    "fonts",
    "font_picker",
    "font_renderer",
    "audio",
    "audio_picker",
    "audio_renderer",
    "video",
    "video_picker",
    "video_renderer",
    "image",
    "image_picker",
    "image_renderer",
    "document",
    "document_picker",
    "document_renderer",
    "item_drag_handle",
    "item_drop_target",
    "item_reorder_handle",
    "item_selection_checkbox",
    "item_selection_radio",
    "item_selection_switch",
    "apply",
    "clear",
    "select_all",
    "deselect_all",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
    "presets",
    "skins",
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

DATASET_KEYS = {
    "items",
    "source",
    "sources",
    "dataset_id",
    "count",
    "total",
    "loading",
    "error",
    "cache_key",
    "cache_policy",
    "has_more",
}
PAGINATION_KEYS = {"page", "page_size", "total", "has_more", "infinite_scroll"}
QUERY_KEYS = {
    "query",
    "filters",
    "tags",
    "sort_by",
    "sort_dir",
    "placeholder",
    "debounce_ms",
    "group_by",
}
LAYOUT_KEYS = {
    "columns",
    "tile_width",
    "tile_height",
    "row_height",
    "spacing",
    "run_spacing",
    "adaptive",
    "virtualized",
    "view_mode",
}
SELECTION_KEYS = {
    "selectable",
    "selection_mode",
    "selected_ids",
    "active_id",
    "multi_select",
    "max_selected",
}
ACTION_KEYS = {
    "actions",
    "action",
    "can_apply",
    "can_clear",
    "can_select_all",
    "can_deselect_all",
    "target",
    "target_slot",
    "confirm",
}
ITEM_KEYS = {
    "id",
    "name",
    "path",
    "mime",
    "format",
    "size",
    "duration",
    "resolution",
    "author",
    "metadata",
    "status",
    "badge",
    "thumbnail",
    "preview_url",
}
MEDIA_KEYS = {
    "preview_url",
    "thumbnail",
    "mime",
    "format",
    "width",
    "height",
    "duration",
    "poster_url",
    "waveform",
}
FONT_KEYS = {
    "sample_text",
    "font_family",
    "font_weight",
    "weights",
    "charsets",
}
DRAG_KEYS = {"draggable", "droppable", "reorderable", "index", "drag_id", "drop_id"}
STATE_KEYS = {"empty_message", "empty_hint", "skeleton_count", "retry_label"}
SKIN_KEYS = {"skin_id", "preset_id", "wallpaper_mode", "theme"}

LAYOUT_MODULES = {"toolbar", "grid_layout", "section_header", "pagination"}
DISCOVERY_MODULES = {"search_bar", "filter_bar", "sort_bar"}
ITEM_MODULES = {
    "item_tile",
    "item_preview",
    "item_meta_row",
    "item_badge",
    "item_actions",
    "item_selectable",
    "item_drag_handle",
    "item_drop_target",
    "item_reorder_handle",
    "item_selection_checkbox",
    "item_selection_radio",
    "item_selection_switch",
}
MEDIA_MODULES = {
    "fonts",
    "font_picker",
    "font_renderer",
    "audio",
    "audio_picker",
    "audio_renderer",
    "video",
    "video_picker",
    "video_renderer",
    "image",
    "image_picker",
    "image_renderer",
    "document",
    "document_picker",
    "document_renderer",
    "presets",
    "skins",
}
SELECTION_MODULES = {
    "item_selectable",
    "item_selection_checkbox",
    "item_selection_radio",
    "item_selection_switch",
    "select_all",
    "deselect_all",
    "apply",
    "clear",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
}
ACTION_MODULES = {
    "apply",
    "clear",
    "select_all",
    "deselect_all",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
}
DRAG_MODULES = {"item_drag_handle", "item_drop_target", "item_reorder_handle"}

MODULE_EXTRA_KEYS = {
    "toolbar": {"upload_enabled", "import_enabled"},
    "filter_bar": {"filter_groups", "active_filters"},
    "grid_layout": {"min_columns", "max_columns"},
    "item_actions": {"primary_action", "secondary_actions"},
    "item_badge": {"color", "bgcolor", "priority"},
    "item_meta_row": {"date_added", "kind"},
    "item_preview": {"fit", "autoplay"},
    "item_tile": {"selected", "favorite"},
    "pagination": {"cursor"},
    "section_header": {"section_id", "section_index", "collapsible", "collapsed"},
    "sort_bar": {"sort_options"},
    "empty_state": {"cta_label", "cta_action"},
    "loading_skeleton": {"animated"},
    "search_bar": {"live", "search_scope"},
    "fonts": {"families"},
    "font_picker": {"selected_font"},
    "font_renderer": {"preview_size"},
    "audio": {"sample_rate", "channels"},
    "audio_picker": {"selected_audio"},
    "audio_renderer": {"playing", "position_ms"},
    "video": {"fps"},
    "video_picker": {"selected_video"},
    "video_renderer": {"muted", "loop"},
    "image": {"dpi"},
    "image_picker": {"selected_image"},
    "image_renderer": {"fit"},
    "document": {"pages"},
    "document_picker": {"selected_document"},
    "document_renderer": {"page"},
    "item_drag_handle": {"drag_group"},
    "item_drop_target": {"drop_group"},
    "item_reorder_handle": {"from_index", "to_index"},
    "item_selection_checkbox": {"checked"},
    "item_selection_radio": {"choice"},
    "item_selection_switch": {"on"},
    "apply_font": {"selected_font"},
    "apply_image": {"selected_image"},
    "set_as_wallpaper": {"selected_image"},
    "presets": {"preset_groups"},
    "skins": {"skin_groups"},
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
    "items": "list",
    "source": "string",
    "sources": "list",
    "dataset_id": "string",
    "count": "int",
    "total": "int",
    "loading": "bool",
    "error": "string",
    "cache_key": "string",
    "cache_policy": "string",
    "has_more": "bool",
    "page": "int",
    "page_size": "int",
    "infinite_scroll": "bool",
    "query": "string",
    "filters": "map",
    "sort_by": "string",
    "sort_dir": "string",
    "placeholder": "string",
    "debounce_ms": "int",
    "group_by": "string",
    "columns": "int",
    "tile_width": "dimension",
    "tile_height": "dimension",
    "row_height": "dimension",
    "spacing": "num",
    "run_spacing": "num",
    "adaptive": "bool",
    "virtualized": "bool",
    "view_mode": "string",
    "selectable": "bool",
    "selection_mode": "string",
    "selected_ids": "list",
    "active_id": "string",
    "multi_select": "bool",
    "max_selected": "int",
    "actions": "list",
    "action": "string",
    "can_apply": "bool",
    "can_clear": "bool",
    "can_select_all": "bool",
    "can_deselect_all": "bool",
    "target": "string",
    "target_slot": "string",
    "confirm": "bool",
}

TYPE_HINTS.update(
    {
        "id": "string",
        "name": "string",
        "path": "string",
        "mime": "string",
        "format": "string",
        "size": "int",
        "duration": "num",
        "resolution": "string",
        "author": "string",
        "metadata": "map",
        "status": "string",
        "badge": "string",
        "thumbnail": "string",
        "preview_url": "string",
        "width": "int",
        "height": "int",
        "poster_url": "string",
        "waveform": "list",
        "sample_text": "string",
        "font_family": "string",
        "font_weight": "string",
        "weights": "list",
        "charsets": "list",
        "draggable": "bool",
        "droppable": "bool",
        "reorderable": "bool",
        "index": "int",
        "drag_id": "string",
        "drop_id": "string",
        "empty_message": "string",
        "empty_hint": "string",
        "skeleton_count": "int",
        "retry_label": "string",
        "skin_id": "string",
        "preset_id": "string",
        "wallpaper_mode": "string",
        "theme": "map",
        "upload_enabled": "bool",
        "import_enabled": "bool",
        "filter_groups": "list",
        "active_filters": "map",
        "min_columns": "int",
        "max_columns": "int",
        "primary_action": "string",
        "secondary_actions": "list",
        "color": "color",
        "bgcolor": "color",
        "priority": "int",
        "date_added": "string",
        "kind": "string",
        "fit": "string",
        "autoplay": "bool",
        "selected": "bool",
        "favorite": "bool",
        "cursor": "string",
        "section_id": "string",
        "section_index": "int",
        "collapsible": "bool",
        "collapsed": "bool",
        "sort_options": "list",
        "cta_label": "string",
        "cta_action": "string",
        "animated": "bool",
        "live": "bool",
        "search_scope": "string",
        "families": "list",
        "selected_font": "string",
        "preview_size": "num",
        "sample_rate": "int",
        "channels": "int",
        "selected_audio": "string",
        "playing": "bool",
        "position_ms": "int",
        "fps": "num",
        "selected_video": "string",
        "muted": "bool",
        "loop": "bool",
        "dpi": "num",
        "selected_image": "string",
        "pages": "int",
        "selected_document": "string",
        "drag_group": "string",
        "drop_group": "string",
        "from_index": "int",
        "to_index": "int",
        "checked": "bool",
        "choice": "string",
        "on": "bool",
        "preset_groups": "list",
        "skin_groups": "list",
    }
)

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


def _to_python_hint(type_name: str) -> str:
    return TYPE_TO_PY.get(type_name, "object")


def _build_allowed_keys() -> dict[str, set[str]]:
    allowed = {token: set(COMMON_KEYS) for token in GALLERY_MODULES}

    for token in LAYOUT_MODULES:
        allowed[token].update(DATASET_KEYS)
        allowed[token].update(LAYOUT_KEYS)
        allowed[token].update(ACTION_KEYS)

    for token in DISCOVERY_MODULES:
        allowed[token].update(QUERY_KEYS)
        allowed[token].update(DATASET_KEYS)
        allowed[token].update(SELECTION_KEYS)

    for token in ITEM_MODULES:
        allowed[token].update(ITEM_KEYS)
        allowed[token].update(SELECTION_KEYS)
        allowed[token].update(ACTION_KEYS)
        allowed[token].update(DRAG_KEYS)

    for token in MEDIA_MODULES:
        allowed[token].update(DATASET_KEYS)
        allowed[token].update(QUERY_KEYS)
        allowed[token].update(SELECTION_KEYS)
        allowed[token].update(ACTION_KEYS)
        allowed[token].update(ITEM_KEYS)
        allowed[token].update(MEDIA_KEYS)
        allowed[token].update(FONT_KEYS)
        allowed[token].update(SKIN_KEYS)

    for token in ACTION_MODULES:
        allowed[token].update(SELECTION_KEYS)
        allowed[token].update(ACTION_KEYS)
        allowed[token].update(ITEM_KEYS)
        allowed[token].update(SKIN_KEYS)
        allowed[token].update(FONT_KEYS)

    for token in DRAG_MODULES:
        allowed[token].update(DRAG_KEYS)
        allowed[token].update(SELECTION_KEYS)
        allowed[token].update(ITEM_KEYS)

    allowed["empty_state"].update(STATE_KEYS | ACTION_KEYS | QUERY_KEYS)
    allowed["loading_skeleton"].update(STATE_KEYS | LAYOUT_KEYS | DATASET_KEYS)
    allowed["pagination"].update(PAGINATION_KEYS)

    for token, keys in MODULE_EXTRA_KEYS.items():
        allowed[token].update(keys)

    return allowed


def _events_for_module(token: str) -> list[str]:
    events = {"change", "module_change", "state_change"}
    if token in DISCOVERY_MODULES:
        events.update({"filter_change", "sort_change", "change"})
    if token in SELECTION_MODULES or token in ITEM_MODULES:
        events.update({"select", "select_change"})
    if token in ACTION_MODULES:
        events.update({"action"})
    if token in {"apply", "apply_font", "apply_image", "set_as_wallpaper"}:
        events.add("apply")
    if token == "clear":
        events.add("clear")
    if token == "select_all":
        events.add("select_all")
    if token == "deselect_all":
        events.add("deselect_all")
    if token == "apply_font":
        events.add("apply_font")
    if token == "apply_image":
        events.add("apply_image")
    if token == "set_as_wallpaper":
        events.add("set_as_wallpaper")
    if token in MEDIA_MODULES:
        events.add("pick")
    if token == "pagination":
        events.add("page_change")
    if token in DRAG_MODULES:
        events.update({"drag_handle", "drop_target"})
    if token in {"toolbar", "section_header"}:
        events.add("section_action")
    if token in {"fonts", "font_picker", "font_renderer", "apply_font"}:
        events.add("font_change")
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
        "register_source",
        "register_type",
        "register_view",
        "register_panel",
        "register_apply_adapter",
        "register_command",
    }
    if token in DISCOVERY_MODULES:
        actions.update({"set_query", "set_filters", "set_sort"})
    if token in SELECTION_MODULES or token in ITEM_MODULES:
        actions.update({"select", "toggle_select", "select_all", "deselect_all"})
    if token in ACTION_MODULES:
        actions.update({"apply", "clear"})
    if token == "apply_font":
        actions.add("apply_font")
    if token == "apply_image":
        actions.add("apply_image")
    if token == "set_as_wallpaper":
        actions.add("set_as_wallpaper")
    if token == "pagination":
        actions.update({"set_page", "set_page_size", "load_more"})
    if token in DRAG_MODULES:
        actions.update({"start_drag", "drop", "reorder"})
    if token in MEDIA_MODULES:
        actions.update({"pick", "preview"})
    if token == "empty_state":
        actions.update({"retry", "upload", "import"})
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
        "from .control import GallerySubmodule",
        "from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES",
        "",
        f'MODULE_TOKEN = "{module}"',
        "",
        "",
        f"class {class_name}(GallerySubmodule):",
        f'    """Gallery submodule host control for `{module}`."""',
        "",
        f'    control_type = "gallery_{module}"',
        '    umbrella = "gallery"',
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
        "        *children: object,",
        "        payload: Mapping[str, object] | None = None,",
        "        props: Mapping[str, object] | None = None,",
        "        style: Mapping[str, object] | None = None,",
        "        strict: bool = False,",
    ]
    for key in module_keys:
        type_name = _to_python_hint(module_key_types.get(key, "any"))
        lines.append(f"        {key}: {type_name} | None = None,")
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
            "            *children,",
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


def _submodules_init_text() -> str:
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


def _schema_text(
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
        'CONTROL_PREFIX = "gallery"',
        "",
        "MODULE_TOKENS = tuple(str(module) for module in UMBRELLA_MODULES)",
        "MODULE_CANONICAL = MODULE_TOKENS",
        "SUPPORTED_EVENTS = tuple(str(event) for event in UMBRELLA_EVENTS)",
        "",
        f"MODULE_CLASS_NAMES = {_render_dict_of_str(class_names)}",
        "",
        f"GALLERY_COMMON_PAYLOAD_KEYS = {_render_set(COMMON_KEYS)}",
        "",
        f"GALLERY_COMMON_PAYLOAD_TYPES = {_render_dict_of_str(common_types)}",
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
        '    "GALLERY_COMMON_PAYLOAD_KEYS",',
        '    "GALLERY_COMMON_PAYLOAD_TYPES",',
        '    "MODULE_ALLOWED_KEYS",',
        '    "MODULE_PAYLOAD_TYPES",',
        '    "MODULE_EVENTS",',
        '    "MODULE_ACTIONS",',
        "]",
    ]
    return "\n".join(lines) + "\n"


def _control_text() -> str:
    return dedent(
        """
        from __future__ import annotations

        from collections.abc import Iterable, Mapping
        from typing import Any

        from ..._shared import merge_props
        from ..._umbrella_runtime import _normalize_events, _normalize_state, _normalize_token
        from ..control import GALLERY_EVENTS, GALLERY_SCHEMA_VERSION, GALLERY_STATES, Gallery
        from .schema import (
            GALLERY_COMMON_PAYLOAD_KEYS,
            GALLERY_COMMON_PAYLOAD_TYPES,
            MODULE_ACTIONS,
            MODULE_ALLOWED_KEYS,
            MODULE_EVENTS,
            MODULE_PAYLOAD_TYPES,
        )


        def _coerce_mapping(value: Any) -> dict[str, Any]:
            if isinstance(value, Mapping):
                return dict(value)
            return {}


        def _coerce_modules(value: Mapping[str, Any] | None) -> dict[str, Any]:
            out: dict[str, Any] = {}
            if isinstance(value, Mapping):
                for key, item in value.items():
                    token = _normalize_token(str(key))
                    if not token:
                        continue
                    if isinstance(item, Mapping):
                        out[token] = dict(item)
                    elif item is not None:
                        out[token] = item
            return out


        def _coerce_string(value: Any, *, fallback: str = "") -> str:
            text = str(value).strip() if value is not None else ""
            if text:
                return text
            return fallback


        def _coerce_contributions(value: Any) -> dict[str, Any]:
            if not isinstance(value, Mapping):
                return {}
            out: dict[str, Any] = {}
            for raw_key, raw_value in value.items():
                key = _normalize_token(str(raw_key))
                if not key:
                    continue
                out[key] = raw_value
            return out


        def _normalize_dependencies(values: Any) -> tuple[str, ...]:
            out: list[str] = []
            if isinstance(values, (list, tuple, set)):
                for item in values:
                    token = _normalize_token(str(item))
                    if token and token not in out:
                        out.append(token)
            elif values is not None:
                token = _normalize_token(str(values))
                if token:
                    out.append(token)
            return tuple(out)


        def _module_metadata(submodule: "GallerySubmodule") -> dict[str, Any]:
            canonical_module = _normalize_token(
                str(getattr(submodule, "canonical_module", getattr(submodule, "module_token", "")))
            )
            module_token = _normalize_token(str(getattr(submodule, "module_token", canonical_module)))
            module_id = _coerce_string(getattr(submodule, "module_id", None), fallback=module_token)
            module_version = _coerce_string(getattr(submodule, "module_version", None), fallback="1.0.0")
            depends_on = list(_normalize_dependencies(getattr(submodule, "module_depends_on", ())))
            contributions = _coerce_contributions(getattr(submodule, "module_contributions", {}))
            return {
                "id": module_id,
                "version": module_version,
                "depends_on": depends_on,
                "contributions": contributions,
            }


        def _is_color_like(value: Any) -> bool:
            if isinstance(value, int):
                return True
            if isinstance(value, str):
                text = value.strip().lower()
                if text.startswith("#") and len(text) in {4, 5, 7, 9}:
                    return True
                return bool(text)
            return False


        def _is_type_match(
            expected: str,
            value: Any,
            *,
            allowed_events: set[str],
            allowed_states: set[str],
        ) -> bool:
            if value is None:
                return True
            if expected == "any":
                return True
            if expected == "bool":
                return isinstance(value, bool)
            if expected == "string":
                return isinstance(value, str)
            if expected == "num":
                return isinstance(value, (int, float)) and not isinstance(value, bool)
            if expected == "int":
                return isinstance(value, int) and not isinstance(value, bool)
            if expected == "map":
                return isinstance(value, Mapping)
            if expected == "list":
                return isinstance(value, list)
            if expected == "events":
                if not isinstance(value, list):
                    return False
                return all(
                    isinstance(item, str) and _normalize_token(item) in allowed_events
                    for item in value
                )
            if expected == "state":
                return isinstance(value, str) and _normalize_token(value) in allowed_states
            if expected == "color":
                return _is_color_like(value)
            if expected == "dimension":
                return isinstance(value, (int, float, str))
            return True


        def _sanitize_module_payload(module: str, payload: Mapping[str, Any]) -> dict[str, Any]:
            normalized_module = _normalize_token(module)
            allowed_keys = set(GALLERY_COMMON_PAYLOAD_KEYS) | set(MODULE_ALLOWED_KEYS.get(normalized_module, set()))
            type_map = dict(GALLERY_COMMON_PAYLOAD_TYPES)
            type_map.update(MODULE_PAYLOAD_TYPES.get(normalized_module, {}))
            allowed_events = {str(event) for event in GALLERY_EVENTS}
            allowed_states = {str(state) for state in GALLERY_STATES}

            out: dict[str, Any] = {}
            for raw_key, raw_value in payload.items():
                key = _normalize_token(str(raw_key))
                if not key or key not in allowed_keys:
                    continue
                expected = str(type_map.get(key, "any"))
                if _is_type_match(
                    expected,
                    raw_value,
                    allowed_events=allowed_events,
                    allowed_states=allowed_states,
                ):
                    out[key] = raw_value
            return out


        class GallerySubmodule(Gallery):
            module_token: str = ""
            canonical_module: str = ""
            module_id: str = ""
            module_version: str = "1.0.0"
            module_depends_on: tuple[str, ...] = ()
            module_contributions: dict[str, Any] = {}
            module_props: tuple[str, ...] = ()
            module_prop_types: dict[str, str] = {}
            supported_events: tuple[str, ...] = tuple(sorted(GALLERY_EVENTS))
            supported_actions: tuple[str, ...] = (
                "set_payload",
                "set_props",
                "set_module",
                "set_state",
                "get_state",
                "set_items",
                "emit",
                "trigger",
                "activate",
                "emit_change",
                "register_module",
                "register_source",
                "register_type",
                "register_view",
                "register_panel",
                "register_apply_adapter",
                "register_command",
            )
            base_props: tuple[str, ...] = (
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
                "items",
                "radius",
                "spacing",
                "run_spacing",
                "tile_width",
                "tile_height",
                "selectable",
                "enabled",
            )
            supported_props: tuple[str, ...] = base_props

            def __init_subclass__(cls, **kwargs: Any) -> None:
                super().__init_subclass__(**kwargs)
                module_token = _normalize_token(str(getattr(cls, "module_token", "")))
                canonical_module = _normalize_token(str(getattr(cls, "canonical_module", module_token)))
                if not canonical_module:
                    canonical_module = module_token
                if module_token and not _normalize_token(str(getattr(cls, "module_id", ""))):
                    cls.module_id = module_token
                cls.module_version = _coerce_string(getattr(cls, "module_version", None), fallback="1.0.0")
                cls.module_depends_on = _normalize_dependencies(getattr(cls, "module_depends_on", ()))
                cls.module_contributions = _coerce_contributions(getattr(cls, "module_contributions", {}))
                if module_token:
                    cls.module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(module_token, set())))
                    cls.module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(module_token, {}))
                    cls.supported_events = tuple(
                        MODULE_EVENTS.get(module_token, tuple(sorted(GALLERY_EVENTS)))
                    )
                    cls.supported_actions = tuple(
                        MODULE_ACTIONS.get(module_token, cls.supported_actions)
                    )

                all_props = list(cls.base_props)
                all_props.extend(cls.module_props)
                all_props.extend(GALLERY_COMMON_PAYLOAD_KEYS)
                if module_token:
                    all_props.append(module_token)
                if canonical_module and canonical_module != module_token:
                    all_props.append(canonical_module)
                cls.supported_props = tuple(
                    dict.fromkeys(_normalize_token(prop) for prop in all_props if prop)
                )

            def __init__(
                self,
                *children: Any,
                payload: Mapping[str, Any] | None = None,
                module_payload: Mapping[str, Any] | None = None,
                events: Iterable[str] | None = None,
                state: str | None = None,
                custom_layout: bool | None = None,
                layout: str | None = None,
                items: list[Any] | None = None,
                manifest: Mapping[str, Any] | None = None,
                registries: Mapping[str, Any] | None = None,
                modules: Mapping[str, Any] | None = None,
                props: Mapping[str, Any] | None = None,
                style: Mapping[str, Any] | None = None,
                strict: bool = False,
                **kwargs: Any,
            ) -> None:
                module_token = _normalize_token(str(getattr(self, "module_token", "")))
                canonical_module = _normalize_token(str(getattr(self, "canonical_module", module_token)))
                if not module_token:
                    raise ValueError("GallerySubmodule requires module_token on subclass")
                if not canonical_module:
                    canonical_module = module_token

                kwargs.pop("module", None)
                kwargs.pop("module_id", None)

                merged_payload = _coerce_mapping(module_payload)
                merged_payload.update(_coerce_mapping(payload))
                token_payload = kwargs.pop(module_token, None)
                merged_payload.update(_coerce_mapping(token_payload))
                if canonical_module != module_token:
                    canonical_payload = kwargs.pop(canonical_module, None)
                    merged_payload.update(_coerce_mapping(canonical_payload))
                merged_payload.update({k: v for k, v in kwargs.items() if v is not None})
                merged_payload = _sanitize_module_payload(canonical_module, merged_payload)
                submodule_meta = _module_metadata(self)

                merged_modules = _coerce_modules(modules)
                section_payload = _coerce_mapping(merged_modules.get(canonical_module))
                section_payload.update(merged_payload)
                section_payload = _sanitize_module_payload(canonical_module, section_payload)
                merged_modules[canonical_module] = section_payload

                manifest_payload = dict(manifest or {})
                enabled_modules: list[str] = []
                if isinstance(manifest_payload.get("enabled_modules"), list):
                    for item in manifest_payload["enabled_modules"]:
                        token = _normalize_token(str(item))
                        if token and token not in enabled_modules:
                            enabled_modules.append(token)
                if canonical_module and canonical_module not in enabled_modules:
                    enabled_modules.append(canonical_module)
                manifest_payload["enabled_modules"] = enabled_modules
                module_versions = _coerce_mapping(manifest_payload.get("module_versions"))
                module_versions[canonical_module] = submodule_meta["version"]
                manifest_payload["module_versions"] = module_versions
                module_dependencies = _coerce_mapping(manifest_payload.get("module_dependencies"))
                module_dependencies[canonical_module] = list(submodule_meta["depends_on"])
                manifest_payload["module_dependencies"] = module_dependencies

                normalized_events = _normalize_events(events)
                if normalized_events is None:
                    normalized_events = [event for event in self.supported_events if event in GALLERY_EVENTS]
                    if not normalized_events:
                        normalized_events = sorted(GALLERY_EVENTS)

                merged = merge_props(
                    props,
                    module=canonical_module,
                    module_id=module_token,
                    state=_normalize_state(state) if state is not None else None,
                    custom_layout=custom_layout,
                    layout=layout,
                    events=normalized_events,
                    items=items,
                    manifest=manifest_payload,
                    registries=dict(registries or {}),
                    modules=merged_modules,
                    submodule_meta=submodule_meta,
                    schema_version=GALLERY_SCHEMA_VERSION,
                )

                top_level_payload = _coerce_mapping(merged.get(canonical_module))
                top_level_payload.update(section_payload)
                top_level_payload = _sanitize_module_payload(canonical_module, top_level_payload)
                merged[canonical_module] = top_level_payload

                module_map = _coerce_mapping(merged.get("modules"))
                module_section = _coerce_mapping(module_map.get(canonical_module))
                module_section.update(top_level_payload)
                module_section = _sanitize_module_payload(canonical_module, module_section)
                module_section["submodule_meta"] = dict(submodule_meta)
                module_map[canonical_module] = module_section
                merged["modules"] = module_map
                merged["submodule_meta"] = dict(submodule_meta)

                super().__init__(
                    *children,
                    module=canonical_module,
                    modules=module_map,
                    props=merged,
                    style=style,
                    strict=strict,
                    **{canonical_module: module_section},
                )
                self.props.setdefault("supported_events", list(self.supported_events))
                self.props.setdefault("supported_actions", list(self.supported_actions))
                self.props.setdefault("supported_props", list(self.supported_props))
                self.props.setdefault("module_props", list(self.module_props))
                self.props.setdefault("module_prop_types", dict(self.module_prop_types))
                self.props.setdefault("submodule_meta", dict(submodule_meta))

            def set_payload(
                self,
                session: Any,
                payload: Mapping[str, Any] | None = None,
                **kwargs: Any,
            ) -> dict[str, Any]:
                update_payload = _coerce_mapping(payload)
                if kwargs:
                    update_payload.update(dict(kwargs))
                module_name = _normalize_token(str(getattr(self, "canonical_module", self.module_token)))
                update_payload = _sanitize_module_payload(module_name, update_payload)
                current = _coerce_mapping(self.props.get(module_name))
                current.update(update_payload)
                current = _sanitize_module_payload(module_name, current)
                self.props[module_name] = current
                modules = _coerce_mapping(self.props.get("modules"))
                modules[module_name] = current
                self.props["modules"] = modules
                return self.set_module(session, module_name, current)

            def activate(self, session: Any) -> dict[str, Any]:
                module_name = _normalize_token(str(getattr(self, "canonical_module", self.module_token)))
                current_payload = _coerce_mapping(self.props.get(module_name))
                current_payload = _sanitize_module_payload(module_name, current_payload)
                return self.set_module(session, module_name, current_payload)

            def emit_change(
                self,
                session: Any,
                payload: Mapping[str, Any] | None = None,
                **kwargs: Any,
            ) -> dict[str, Any]:
                update_payload = _coerce_mapping(payload)
                if kwargs:
                    update_payload.update(dict(kwargs))
                module_name = _normalize_token(str(getattr(self, "canonical_module", self.module_token)))
                update_payload = _sanitize_module_payload(module_name, update_payload)
                return self.emit(session, "change", {"module": module_name, "payload": update_payload})

            def run_action(
                self,
                session: Any,
                action: str,
                payload: Mapping[str, Any] | None = None,
                **kwargs: Any,
            ) -> dict[str, Any]:
                normalized_action = _normalize_token(action)
                if normalized_action not in set(self.supported_actions):
                    return {
                        "ok": False,
                        "error": (
                            "Unsupported gallery submodule action "
                            f"'{normalized_action}' for module '{self.canonical_module}'"
                        ),
                    }
                payload_dict = _coerce_mapping(payload)
                if kwargs:
                    payload_dict.update(dict(kwargs))
                if normalized_action == "set_payload":
                    return self.set_payload(session, payload_dict)
                if normalized_action == "activate":
                    return self.activate(session)
                if normalized_action == "emit_change":
                    return self.emit_change(session, payload_dict)
                method = getattr(self, normalized_action, None)
                if callable(method):
                    if payload_dict:
                        return method(session, payload=payload_dict)
                    return method(session)
                return self.invoke(session, normalized_action, payload_dict)

            def emit_event(
                self,
                session: Any,
                event: str,
                payload: Mapping[str, Any] | None = None,
                **kwargs: Any,
            ) -> dict[str, Any]:
                normalized_event = _normalize_token(event)
                if normalized_event not in set(self.supported_events):
                    return {
                        "ok": False,
                        "error": (
                            "Unsupported gallery submodule event "
                            f"'{normalized_event}' for module '{self.canonical_module}'"
                        ),
                    }
                payload_dict = _coerce_mapping(payload)
                if kwargs:
                    payload_dict.update(dict(kwargs))
                return self.emit(session, normalized_event, payload_dict)

            def describe_contract(self) -> dict[str, Any]:
                metadata = _module_metadata(self)
                return {
                    "module": getattr(self, "canonical_module", self.module_token),
                    "module_id": getattr(self, "module_token", ""),
                    "control_type": getattr(self, "control_type", "gallery"),
                    "id": metadata["id"],
                    "version": metadata["version"],
                    "depends_on": list(metadata["depends_on"]),
                    "contributions": dict(metadata["contributions"]),
                    "submodule_meta": dict(metadata),
                    "supported_events": list(self.supported_events),
                    "supported_actions": list(self.supported_actions),
                    "supported_props": list(self.supported_props),
                    "module_props": list(self.module_props),
                    "module_prop_types": dict(self.module_prop_types),
                }


        __all__ = ["GallerySubmodule"]
        """
    ).strip() + "\n"


def _root_init_text(modules: list[str], class_names: dict[str, str]) -> str:
    class_imports = ",\n    ".join(class_names[module] for module in modules)
    bind_lines: list[str] = []
    for module in modules:
        cls = class_names[module]
        bind_lines.append(f"Gallery.{module} = {cls}")
        bind_lines.append(f"Gallery.{cls} = {cls}")
    module_exports = ",\n    ".join(f'"{class_names[module]}"' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .control import Gallery\n"
        "from .submodules import (\n"
        f"    {class_imports},\n"
        ")\n"
        "from .schema import (\n"
        "    EVENTS,\n"
        "    MODULES,\n"
        "    REGISTRY_MANIFEST_LISTS,\n"
        "    REGISTRY_ROLE_ALIASES,\n"
        "    SCHEMA_VERSION,\n"
        "    STATES,\n"
        ")\n\n"
        f"{chr(10).join(bind_lines)}\n\n"
        "__all__ = [\n"
        '    "Gallery",\n'
        '    "SCHEMA_VERSION",\n'
        '    "MODULES",\n'
        '    "STATES",\n'
        '    "EVENTS",\n'
        '    "REGISTRY_ROLE_ALIASES",\n'
        '    "REGISTRY_MANIFEST_LISTS",\n'
        '    "MODULE_COMPONENTS",\n'
        f"    {module_exports},\n"
        "]\n"
    )


def _root_stub_text(modules: list[str], class_names: dict[str, str]) -> str:
    class_imports = ",\n    ".join(class_names[module] for module in modules)
    class_attrs: list[str] = []
    for module in modules:
        cls = class_names[module]
        class_attrs.append(f"    {module}: type[{cls}]")
        class_attrs.append(f"    {cls}: type[{cls}]")
    module_exports = ",\n    ".join(f'"{class_names[module]}"' for module in modules)
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .control import Gallery as _Gallery\n"
        "from .submodules import (\n"
        f"    {class_imports},\n"
        ")\n"
        "from .schema import (\n"
        "    EVENTS,\n"
        "    MODULES,\n"
        "    REGISTRY_MANIFEST_LISTS,\n"
        "    REGISTRY_ROLE_ALIASES,\n"
        "    SCHEMA_VERSION,\n"
        "    STATES,\n"
        ")\n\n"
        "class Gallery(_Gallery):\n"
        f"{chr(10).join(class_attrs)}\n\n"
        "__all__ = [\n"
        '    "Gallery",\n'
        '    "SCHEMA_VERSION",\n'
        '    "MODULES",\n'
        '    "STATES",\n'
        '    "EVENTS",\n'
        '    "REGISTRY_ROLE_ALIASES",\n'
        '    "REGISTRY_MANIFEST_LISTS",\n'
        '    "MODULE_COMPONENTS",\n'
        f"    {module_exports},\n"
        "]\n"
    )


def _parse_dart_registry_modules(path: Path, variable_name: str) -> set[str]:
    text = path.read_text(encoding="utf-8")
    pattern = rf"{re.escape(variable_name)}\s*=\s*\{{(.*?)\}};"
    match = re.search(pattern, text, re.S)
    if not match:
        raise RuntimeError(f"Could not parse Dart registry set: {variable_name}")
    return set(re.findall(r"'([a-z0-9_]+)'", match.group(1)))


def main() -> None:
    modules = list(GALLERY_MODULES)
    class_names = {module: _pascal(module) for module in modules}
    allowed = _build_allowed_keys()
    events = {module: _events_for_module(module) for module in modules}
    actions = {module: _actions_for_module(module) for module in modules}
    module_types = {
        module: {key: TYPE_HINTS.get(key, "any") for key in sorted(allowed[module])}
        for module in modules
    }

    SUBMODULES_DIR.mkdir(parents=True, exist_ok=True)

    SCHEMA_PATH.write_text(_schema_text(class_names, allowed, events, actions), encoding="utf-8")
    CONTROL_PATH.write_text(_control_text(), encoding="utf-8")

    for file_path in SUBMODULES_DIR.glob("*.py"):
        if file_path.name in SPECIAL_FILES:
            continue
        if file_path.stem not in modules:
            file_path.unlink()

    for module in modules:
        class_name = class_names[module]
        module_keys = sorted(allowed.get(module, set()) - COMMON_KEYS)
        module_key_types = module_types.get(module, {})
        module_path = SUBMODULES_DIR / f"{module}.py"
        module_path.write_text(
            _module_text(module, class_name, module_keys, module_key_types),
            encoding="utf-8",
        )

    (SUBMODULES_DIR / "components.py").write_text(
        _components_text(modules, class_names),
        encoding="utf-8",
    )
    (SUBMODULES_DIR / "__init__.py").write_text(_submodules_init_text(), encoding="utf-8")
    (SUBMODULES_DIR / "family.py").write_text(_family_text(), encoding="utf-8")
    ROOT_INIT_PATH.write_text(_root_init_text(modules, class_names), encoding="utf-8")
    ROOT_INIT_PATH.with_suffix(".pyi").write_text(
        _root_stub_text(modules, class_names),
        encoding="utf-8",
    )

    dart_modules = _parse_dart_registry_modules(DART_REGISTRY, "galleryRegistryModules")
    py_modules = set(modules)
    missing_in_dart = sorted(py_modules - dart_modules)
    missing_in_py = sorted(dart_modules - py_modules)
    if missing_in_dart or missing_in_py:
        raise RuntimeError(
            "Gallery Python/Dart registry mismatch: "
            f"missing_in_dart={missing_in_dart}, missing_in_py={missing_in_py}"
        )

    print(f"Wired Gallery submodules: {len(modules)} modules")


if __name__ == "__main__":
    main()
