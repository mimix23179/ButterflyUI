from __future__ import annotations

import keyword
import re
from dataclasses import dataclass
from pathlib import Path

TYPE_TO_PY: dict[str, str] = {
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
    "alignment": "str | Mapping[str, object] | list[object]",
    "padding": "int | float | Mapping[str, object] | list[object]",
}


@dataclass(slots=True)
class UmbrellaWireConfig:
    umbrella: str
    umbrella_class: str
    submodule_class: str
    schema_version_const: str
    events_const: str
    states_const: str
    normalize_module_fn: str
    modules: list[str]
    common_payload_keys: set[str]
    common_payload_types: dict[str, str]
    module_allowed_keys: dict[str, set[str]]
    module_payload_types: dict[str, dict[str, str]]
    module_events: dict[str, list[str]]
    module_actions: dict[str, list[str]]
    base_props: tuple[str, ...]
    repo_root: Path
    py_src: Path
    submodules_dir: Path
    root_init_path: Path
    dart_registry_path: Path
    dart_registry_var: str
    root_schema_exports: tuple[str, ...]
    special_files: tuple[str, ...] = ("control.py", "schema.py", "components.py", "__init__.py", "family.py")


def _pascal(token: str) -> str:
    return "".join(part[:1].upper() + part[1:] for part in token.split("_") if part)


def _to_python_hint(type_name: str) -> str:
    return TYPE_TO_PY.get(type_name, "object")


def _render_set(values: set[str], *, indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for value in sorted(values):
        lines.append(f"{pad}    '{value}',")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_sets(values: dict[str, set[str]], *, indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': {{")
        for value in sorted(values[key]):
            lines.append(f"{pad}        '{value}',")
        lines.append(f"{pad}    }},")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_dict(values: dict[str, dict[str, str]], *, indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': {{")
        for sub_key in sorted(values[key]):
            lines.append(f"{pad}        '{sub_key}': '{values[key][sub_key]}',")
        lines.append(f"{pad}    }},")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_str(values: dict[str, str], *, indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': '{values[key]}',")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _render_dict_of_lists(values: dict[str, list[str]], *, indent: int = 0) -> str:
    pad = " " * indent
    lines = [f"{pad}{{"]
    for key in sorted(values):
        lines.append(f"{pad}    '{key}': [")
        for value in values[key]:
            lines.append(f"{pad}        '{value}',")
        lines.append(f"{pad}    ],")
    lines.append(f"{pad}}}")
    return "\n".join(lines)


def _submodules_schema_text(cfg: UmbrellaWireConfig, class_names: dict[str, str]) -> str:
    prefix_upper = cfg.umbrella.upper()
    return (
        "from __future__ import annotations\n\n"
        "from ..schema import EVENTS as UMBRELLA_EVENTS\n"
        "from ..schema import MODULES as UMBRELLA_MODULES\n\n"
        f"CONTROL_PREFIX = '{cfg.umbrella}'\n\n"
        "MODULE_TOKENS = tuple(str(module) for module in UMBRELLA_MODULES)\n"
        "MODULE_CANONICAL = MODULE_TOKENS\n"
        "SUPPORTED_EVENTS = tuple(str(event) for event in UMBRELLA_EVENTS)\n\n"
        f"MODULE_CLASS_NAMES = {_render_dict_of_str(class_names)}\n\n"
        f"{prefix_upper}_COMMON_PAYLOAD_KEYS = {_render_set(cfg.common_payload_keys)}\n\n"
        f"{prefix_upper}_COMMON_PAYLOAD_TYPES = {_render_dict_of_str(cfg.common_payload_types)}\n\n"
        f"MODULE_ALLOWED_KEYS = {_render_dict_of_sets(cfg.module_allowed_keys)}\n\n"
        f"MODULE_PAYLOAD_TYPES = {_render_dict_of_dict(cfg.module_payload_types)}\n\n"
        f"MODULE_EVENTS = {_render_dict_of_lists(cfg.module_events)}\n\n"
        f"MODULE_ACTIONS = {_render_dict_of_lists(cfg.module_actions)}\n\n"
        "__all__ = [\n"
        '    "CONTROL_PREFIX",\n'
        '    "MODULE_TOKENS",\n'
        '    "MODULE_CANONICAL",\n'
        '    "SUPPORTED_EVENTS",\n'
        '    "MODULE_CLASS_NAMES",\n'
        f'    "{prefix_upper}_COMMON_PAYLOAD_KEYS",\n'
        f'    "{prefix_upper}_COMMON_PAYLOAD_TYPES",\n'
        '    "MODULE_ALLOWED_KEYS",\n'
        '    "MODULE_PAYLOAD_TYPES",\n'
        '    "MODULE_EVENTS",\n'
        '    "MODULE_ACTIONS",\n'
        "]\n"
    )


def _submodules_control_text(cfg: UmbrellaWireConfig) -> str:
    prefix_upper = cfg.umbrella.upper()
    return f"""from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ..._shared import merge_props
from ..._umbrella_runtime import _normalize_events, _normalize_state, _normalize_token
from ..control import {cfg.schema_version_const}, {cfg.events_const}, {cfg.states_const}, {cfg.normalize_module_fn}, {cfg.umbrella_class}
from .schema import (
    {prefix_upper}_COMMON_PAYLOAD_KEYS,
    {prefix_upper}_COMMON_PAYLOAD_TYPES,
    MODULE_ACTIONS,
    MODULE_ALLOWED_KEYS,
    MODULE_EVENTS,
    MODULE_PAYLOAD_TYPES,
)


def _coerce_mapping(value: Any) -> dict[str, Any]:
    if isinstance(value, Mapping):
        return dict(value)
    return {{}}


def _coerce_modules(value: Mapping[str, Any] | None) -> dict[str, Any]:
    out: dict[str, Any] = {{}}
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


def _is_color_like(value: Any) -> bool:
    if isinstance(value, int):
        return True
    if isinstance(value, str):
        text = value.strip().lower()
        if text.startswith("#") and len(text) in {{4, 5, 7, 9}}:
            return True
        return bool(text)
    return False


def _is_alignment_like(value: Any) -> bool:
    if isinstance(value, str):
        return bool(_normalize_token(value))
    if isinstance(value, Mapping):
        return "x" in value or "y" in value
    if isinstance(value, list) and len(value) >= 2:
        return True
    return False


def _is_padding_like(value: Any) -> bool:
    if isinstance(value, (int, float)):
        return True
    if isinstance(value, Mapping):
        return True
    if isinstance(value, list):
        return True
    return False


def _is_type_match(expected: str, value: Any, *, allowed_events: set[str], allowed_states: set[str]) -> bool:
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
        return all(isinstance(item, str) and _normalize_token(item) in allowed_events for item in value)
    if expected == "state":
        return isinstance(value, str) and _normalize_token(value) in allowed_states
    if expected == "color":
        return _is_color_like(value)
    if expected == "dimension":
        return isinstance(value, (int, float, str))
    if expected == "alignment":
        return _is_alignment_like(value)
    if expected == "padding":
        return _is_padding_like(value)
    return True


def _sanitize_module_payload(module: str, payload: Mapping[str, Any]) -> dict[str, Any]:
    normalized_module = {cfg.normalize_module_fn}(module) or _normalize_token(module)
    allowed_keys = set({prefix_upper}_COMMON_PAYLOAD_KEYS) | set(MODULE_ALLOWED_KEYS.get(normalized_module, set()))
    type_map = dict({prefix_upper}_COMMON_PAYLOAD_TYPES)
    type_map.update(MODULE_PAYLOAD_TYPES.get(normalized_module, {{}}))

    allowed_events = {{str(event) for event in {cfg.events_const}}}
    allowed_states = {{str(state) for state in {cfg.states_const}}}

    out: dict[str, Any] = {{}}
    for raw_key, raw_value in payload.items():
        key = _normalize_token(str(raw_key))
        if not key or key not in allowed_keys:
            continue
        expected = str(type_map.get(key, "any"))
        if _is_type_match(expected, raw_value, allowed_events=allowed_events, allowed_states=allowed_states):
            out[key] = raw_value
    return out


class {cfg.submodule_class}({cfg.umbrella_class}):
    module_token: str = ""
    canonical_module: str = ""
    module_props: tuple[str, ...] = ()
    module_prop_types: dict[str, str] = {{}}
    supported_events: tuple[str, ...] = tuple(sorted({cfg.events_const}))
    supported_actions: tuple[str, ...] = (
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
    )
    base_props: tuple[str, ...] = {cfg.base_props!r}
    supported_props: tuple[str, ...] = base_props

    def __init_subclass__(cls, **kwargs: Any) -> None:
        super().__init_subclass__(**kwargs)
        module_token = {cfg.normalize_module_fn}(str(getattr(cls, "module_token", ""))) or _normalize_token(
            str(getattr(cls, "module_token", ""))
        )
        canonical_module = {cfg.normalize_module_fn}(str(getattr(cls, "canonical_module", module_token))) or module_token
        if not canonical_module:
            canonical_module = module_token

        if module_token:
            cls.module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(module_token, set())))
            cls.module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(module_token, {{}}))
            cls.supported_events = tuple(MODULE_EVENTS.get(module_token, tuple(sorted({cfg.events_const}))))
            cls.supported_actions = tuple(MODULE_ACTIONS.get(module_token, cls.supported_actions))

        all_props = list(cls.base_props)
        all_props.extend(cls.module_props)
        all_props.extend({prefix_upper}_COMMON_PAYLOAD_KEYS)
        if module_token:
            all_props.append(module_token)
        if canonical_module and canonical_module != module_token:
            all_props.append(canonical_module)
        cls.supported_props = tuple(dict.fromkeys(_normalize_token(prop) for prop in all_props if prop))

    def __init__(
        self,
        payload: Mapping[str, Any] | None = None,
        module_payload: Mapping[str, Any] | None = None,
        events: Iterable[str] | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        manifest: Mapping[str, Any] | None = None,
        registries: Mapping[str, Any] | None = None,
        modules: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        module_token = {cfg.normalize_module_fn}(str(getattr(self, "module_token", ""))) or _normalize_token(
            str(getattr(self, "module_token", ""))
        )
        canonical_module = {cfg.normalize_module_fn}(str(getattr(self, "canonical_module", module_token))) or module_token
        if not module_token:
            raise ValueError("{cfg.submodule_class} requires module_token on subclass")
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

        merged_payload.update({{key: value for key, value in kwargs.items() if value is not None}})
        merged_payload = _sanitize_module_payload(canonical_module, merged_payload)

        merged_modules = _coerce_modules(modules)
        section_payload = _coerce_mapping(merged_modules.get(canonical_module))
        section_payload.update(merged_payload)
        section_payload = _sanitize_module_payload(canonical_module, section_payload)
        merged_modules[canonical_module] = section_payload

        manifest_payload = dict(manifest or {{}})
        manifest_modules_raw = manifest_payload.get("enabled_modules")
        manifest_modules: list[str] = []
        if isinstance(manifest_modules_raw, list):
            for item in manifest_modules_raw:
                token = _normalize_token(str(item))
                if token and token not in manifest_modules:
                    manifest_modules.append(token)
        if canonical_module and canonical_module not in manifest_modules:
            manifest_modules.append(canonical_module)
        manifest_payload["enabled_modules"] = manifest_modules

        normalized_events = _normalize_events(events)
        if normalized_events is None and self.supported_events:
            normalized_events = list(self.supported_events)

        merged = merge_props(
            props,
            module=canonical_module,
            module_id=module_token,
            state=_normalize_state(state) if state is not None else None,
            custom_layout=custom_layout,
            layout=layout,
            events=normalized_events,
            manifest=manifest_payload,
            registries=dict(registries or {{}}),
            modules=merged_modules,
            schema_version={cfg.schema_version_const},
        )

        top_level_payload = _coerce_mapping(merged.get(canonical_module))
        top_level_payload.update(section_payload)
        top_level_payload = _sanitize_module_payload(canonical_module, top_level_payload)
        merged[canonical_module] = top_level_payload

        module_map = _coerce_mapping(merged.get("modules"))
        module_section = _coerce_mapping(module_map.get(canonical_module))
        module_section.update(top_level_payload)
        module_section = _sanitize_module_payload(canonical_module, module_section)
        module_map[canonical_module] = module_section
        merged["modules"] = module_map

        super().__init__(
            module=canonical_module,
            modules=module_map,
            props=merged,
            style=style,
            strict=strict,
            **{{canonical_module: module_section}},
        )
        self.props.setdefault("supported_events", list(self.supported_events))
        self.props.setdefault("supported_actions", list(self.supported_actions))
        self.props.setdefault("supported_props", list(self.supported_props))
        self.props.setdefault("module_props", list(self.module_props))
        self.props.setdefault("module_prop_types", dict(self.module_prop_types))

    def set_payload(self, session: Any, payload: Mapping[str, Any] | None = None, **kwargs: Any) -> dict[str, Any]:
        update_payload = _coerce_mapping(payload)
        if kwargs:
            update_payload.update(dict(kwargs))
        module_name = {cfg.normalize_module_fn}(str(getattr(self, "canonical_module", self.module_token))) or _normalize_token(
            str(getattr(self, "canonical_module", self.module_token))
        )
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
        module_name = {cfg.normalize_module_fn}(str(getattr(self, "canonical_module", self.module_token))) or _normalize_token(
            str(getattr(self, "canonical_module", self.module_token))
        )
        current_payload = _coerce_mapping(self.props.get(module_name))
        current_payload = _sanitize_module_payload(module_name, current_payload)
        return self.set_module(session, module_name, current_payload)

    def emit_change(self, session: Any, payload: Mapping[str, Any] | None = None, **kwargs: Any) -> dict[str, Any]:
        update_payload = _coerce_mapping(payload)
        if kwargs:
            update_payload.update(dict(kwargs))
        module_name = {cfg.normalize_module_fn}(str(getattr(self, "canonical_module", self.module_token))) or _normalize_token(
            str(getattr(self, "canonical_module", self.module_token))
        )
        update_payload = _sanitize_module_payload(module_name, update_payload)
        return self.emit(
            session,
            "change",
            {{
                "module": module_name,
                "payload": update_payload,
            }},
        )

    def run_action(
        self,
        session: Any,
        action: str,
        payload: Mapping[str, Any] | None = None,
        **kwargs: Any,
    ) -> dict[str, Any]:
        normalized_action = _normalize_token(action)
        if normalized_action not in set(self.supported_actions):
            return {{
                "ok": False,
                "error": (
                    "Unsupported {cfg.umbrella} submodule action "
                    f"'{{normalized_action}}' for module '{{self.canonical_module}}'"
                ),
            }}
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
            return {{
                "ok": False,
                "error": (
                    "Unsupported {cfg.umbrella} submodule event "
                    f"'{{normalized_event}}' for module '{{self.canonical_module}}'"
                ),
            }}
        payload_dict = _coerce_mapping(payload)
        if kwargs:
            payload_dict.update(dict(kwargs))
        if payload_dict:
            return self.emit(session, normalized_event, payload_dict)
        return self.emit(session, normalized_event, {{}})

    def describe_contract(self) -> dict[str, Any]:
        return {{
            "module": getattr(self, "canonical_module", self.module_token),
            "module_id": getattr(self, "module_token", ""),
            "control_type": getattr(self, "control_type", "{cfg.umbrella}"),
            "supported_events": list(self.supported_events),
            "supported_actions": list(self.supported_actions),
            "supported_props": list(self.supported_props),
            "module_props": list(self.module_props),
            "module_prop_types": dict(self.module_prop_types),
        }}


__all__ = ["{cfg.submodule_class}"]
"""


def _module_file_text(cfg: UmbrellaWireConfig, module: str, class_name: str, keys: list[str], key_types: dict[str, str]) -> str:
    reserved = {
        "self",
        "payload",
        "props",
        "style",
        "strict",
        "kwargs",
        "session",
        "event",
        "action",
    }
    safe_keys = [
        key
        for key in keys
        if key.isidentifier() and not keyword.iskeyword(key) and key not in reserved
    ]

    lines: list[str] = [
        "from __future__ import annotations",
        "",
        "from collections.abc import Mapping",
        "from typing import Iterable",
        "",
        f"from .control import {cfg.submodule_class}",
        "from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES",
        "",
        f"MODULE_TOKEN = '{module}'",
        "",
        "",
        f"class {class_name}({cfg.submodule_class}):",
        f'    """{cfg.umbrella_class} submodule host control for `{module}`."""',
        "",
        f"    control_type = '{cfg.umbrella}_{module}'",
        f"    umbrella = '{cfg.umbrella}'",
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
    for key in safe_keys:
        hint = _to_python_hint(key_types.get(key, "any"))
        lines.append(f"        {key}: {hint} | None = None,")
    lines.extend(
        [
            "        **kwargs: object,",
            "    ) -> None:",
            "        resolved_payload = dict(payload or {})",
        ]
    )
    for key in safe_keys:
        lines.append(f"        if {key} is not None:")
        lines.append(f"            resolved_payload['{key}'] = {key}")
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
            f"__all__ = ['{class_name}']",
            "",
        ]
    )
    return "\n".join(lines)


def _components_text(modules: list[str], class_names: dict[str, str]) -> str:
    imports = "\n".join(f"from .{token} import {class_names[token]}" for token in modules)
    mapping = "\n".join(f"    '{token}': {class_names[token]}," for token in modules)
    exports = "\n".join(f"    '{class_names[token]}'," for token in modules)
    return (
        "from __future__ import annotations\n\n"
        f"{imports}\n\n"
        "MODULE_COMPONENTS = {\n"
        f"{mapping}\n"
        "}\n\n"
        "globals().update({component.__name__: component for component in MODULE_COMPONENTS.values()})\n\n"
        "__all__ = [\n"
        "    'MODULE_COMPONENTS',\n"
        f"{exports}\n"
        "]\n"
    )


def _submodules_init_text() -> str:
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .components import __all__ as _component_all\n"
        "from .components import *\n"
        "from .schema import CONTROL_PREFIX, MODULE_CANONICAL, MODULE_CLASS_NAMES, MODULE_TOKENS, SUPPORTED_EVENTS\n\n"
        "__all__ = [\n"
        "    'CONTROL_PREFIX',\n"
        "    'MODULE_TOKENS',\n"
        "    'MODULE_CANONICAL',\n"
        "    'SUPPORTED_EVENTS',\n"
        "    'MODULE_CLASS_NAMES',\n"
        "    'MODULE_COMPONENTS',\n"
        "    *_component_all,\n"
        "]\n"
    )


def _family_text() -> str:
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        "from .components import __all__ as _component_all\n"
        "from .components import *\n\n"
        "__all__ = ['MODULE_COMPONENTS', *_component_all]\n"
    )


def _root_init_text(cfg: UmbrellaWireConfig, class_names: dict[str, str]) -> str:
    class_imports = ",\n    ".join(class_names[token] for token in cfg.modules)
    bind_lines: list[str] = []
    for token in cfg.modules:
        cls = class_names[token]
        bind_lines.append(f"{cfg.umbrella_class}.{token}: type[{cls}] = {cls}")
        bind_lines.append(f"{cfg.umbrella_class}.{cls}: type[{cls}] = {cls}")
    module_exports = ",\n    ".join(f'"{class_names[token]}"' for token in cfg.modules)
    schema_imports = ",\n    ".join(cfg.root_schema_exports)
    return (
        "from __future__ import annotations\n\n"
        "from .components import MODULE_COMPONENTS\n"
        f"from .control import {cfg.umbrella_class}\n"
        "from .submodules import (\n"
        f"    {class_imports},\n"
        ")\n"
        "from .schema import (\n"
        f"    {schema_imports},\n"
        ")\n\n"
        f"{chr(10).join(bind_lines)}\n\n"
        "__all__ = [\n"
        f'    "{cfg.umbrella_class}",\n'
        + "".join(f'    "{name}",\n' for name in cfg.root_schema_exports)
        + '    "MODULE_COMPONENTS",\n'
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


def wire_umbrella(cfg: UmbrellaWireConfig) -> int:
    modules = list(cfg.modules)
    class_names = {token: _pascal(token) for token in modules}

    cfg.submodules_dir.mkdir(parents=True, exist_ok=True)

    for file_path in cfg.submodules_dir.glob("*.py"):
        if file_path.name in set(cfg.special_files):
            continue
        if file_path.stem not in modules:
            file_path.unlink()

    for token in modules:
        class_name = class_names[token]
        module_key_types = cfg.module_payload_types.get(token, {})
        module_keys = sorted(cfg.module_allowed_keys.get(token, set()) - cfg.common_payload_keys)
        module_path = cfg.submodules_dir / f"{token}.py"
        module_path.write_text(
            _module_file_text(cfg, token, class_name, module_keys, module_key_types),
            encoding="utf-8",
        )

    (cfg.submodules_dir / "schema.py").write_text(_submodules_schema_text(cfg, class_names), encoding="utf-8")
    (cfg.submodules_dir / "control.py").write_text(_submodules_control_text(cfg), encoding="utf-8")
    (cfg.submodules_dir / "components.py").write_text(_components_text(modules, class_names), encoding="utf-8")
    (cfg.submodules_dir / "__init__.py").write_text(_submodules_init_text(), encoding="utf-8")
    (cfg.submodules_dir / "family.py").write_text(_family_text(), encoding="utf-8")
    cfg.root_init_path.write_text(_root_init_text(cfg, class_names), encoding="utf-8")

    dart_modules = _parse_dart_registry_modules(cfg.dart_registry_path, cfg.dart_registry_var)
    py_modules = set(modules)
    missing_in_dart = sorted(py_modules - dart_modules)
    missing_in_py = sorted(dart_modules - py_modules)
    if missing_in_dart or missing_in_py:
        raise RuntimeError(
            f"{cfg.umbrella_class} Python/Dart registry mismatch: "
            f"missing_in_dart={missing_in_dart}, missing_in_py={missing_in_py}"
        )

    return len(modules)
