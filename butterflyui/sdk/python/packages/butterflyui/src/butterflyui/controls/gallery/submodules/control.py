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
