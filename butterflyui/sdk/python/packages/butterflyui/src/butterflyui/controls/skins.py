from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ..core.schema import ButterflyUIContractError, ensure_valid_props
from ._shared import Component, merge_props

__all__ = ["Skins"]

SKINS_SCHEMA_VERSION = 2

SKINS_MODULES = {
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
}

SKINS_STATES = {"idle", "loading", "ready", "editing", "preview", "disabled"}

SKINS_EVENTS = {
    "change",
    "select",
    "apply",
    "clear",
    "create_skin",
    "edit_skin",
    "delete_skin",
    "state_change",
    "module_change",
    "token_map",
}

SKINS_MODULE_ALIASES = {
    "skins_selector": "selector",
    "skins_preset": "preset",
    "skins_editor": "editor",
    "skins_preview": "preview",
    "skins_apply": "apply",
    "skins_clear": "clear",
    "skins_token_mapper": "token_mapper",
}

SKINS_EVENT_ALIASES = {
    "skins_apply": "apply",
    "skins_clear": "clear",
}


def _normalize_token(value: str | None) -> str:
    if value is None:
        return ""
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def _normalize_module(value: str | None) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    normalized = SKINS_MODULE_ALIASES.get(normalized, normalized)
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


class Skins(Component):
    control_type = "skins"

    def __init__(
        self,
        *children: Any,
        skins: list[Any] | None = None,
        selected_skin: str | None = None,
        presets: list[Any] | None = None,
        value: str | None = None,
        enabled: bool | None = None,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        events: Iterable[str] | None = None,
        modules: Mapping[str, Any] | None = None,
        skins_selector: Mapping[str, Any] | None = None,
        skins_preset: Mapping[str, Any] | None = None,
        skins_editor: Mapping[str, Any] | None = None,
        skins_preview: Mapping[str, Any] | None = None,
        skins_apply: Mapping[str, Any] | None = None,
        skins_clear: Mapping[str, Any] | None = None,
        skins_token_mapper: Mapping[str, Any] | None = None,
        selector: Mapping[str, Any] | None = None,
        preset: Mapping[str, Any] | None = None,
        editor: Mapping[str, Any] | None = None,
        preview: Mapping[str, Any] | None = None,
        apply: Mapping[str, Any] | None = None,
        clear: Mapping[str, Any] | None = None,
        token_mapper: Mapping[str, Any] | None = None,
        create_skin: Mapping[str, Any] | None = None,
        edit_skin: Mapping[str, Any] | None = None,
        delete_skin: Mapping[str, Any] | None = None,
        effects: Mapping[str, Any] | None = None,
        particles: Mapping[str, Any] | None = None,
        shaders: Mapping[str, Any] | None = None,
        materials: Mapping[str, Any] | None = None,
        icons: Mapping[str, Any] | None = None,
        fonts: Mapping[str, Any] | None = None,
        colors: Mapping[str, Any] | None = None,
        background: Mapping[str, Any] | None = None,
        border: Mapping[str, Any] | None = None,
        shadow: Mapping[str, Any] | None = None,
        outline: Mapping[str, Any] | None = None,
        animation: Mapping[str, Any] | None = None,
        transition: Mapping[str, Any] | None = None,
        interaction: Mapping[str, Any] | None = None,
        layout: Mapping[str, Any] | None = None,
        responsive: Mapping[str, Any] | None = None,
        effect_editor: Mapping[str, Any] | None = None,
        particle_editor: Mapping[str, Any] | None = None,
        shader_editor: Mapping[str, Any] | None = None,
        material_editor: Mapping[str, Any] | None = None,
        icon_editor: Mapping[str, Any] | None = None,
        font_editor: Mapping[str, Any] | None = None,
        color_editor: Mapping[str, Any] | None = None,
        background_editor: Mapping[str, Any] | None = None,
        border_editor: Mapping[str, Any] | None = None,
        shadow_editor: Mapping[str, Any] | None = None,
        outline_editor: Mapping[str, Any] | None = None,
        schema_version: int = SKINS_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        module_map: dict[str, Any] = {
            "selector": selector,
            "preset": preset,
            "editor": editor,
            "preview": preview,
            "apply": apply,
            "clear": clear,
            "token_mapper": token_mapper,
            "create_skin": create_skin,
            "edit_skin": edit_skin,
            "delete_skin": delete_skin,
            "effects": effects,
            "particles": particles,
            "shaders": shaders,
            "materials": materials,
            "icons": icons,
            "fonts": fonts,
            "colors": colors,
            "background": background,
            "border": border,
            "shadow": shadow,
            "outline": outline,
            "animation": animation,
            "transition": transition,
            "interaction": interaction,
            "layout": layout,
            "responsive": responsive,
            "effect_editor": effect_editor,
            "particle_editor": particle_editor,
            "shader_editor": shader_editor,
            "material_editor": material_editor,
            "icon_editor": icon_editor,
            "font_editor": font_editor,
            "color_editor": color_editor,
            "background_editor": background_editor,
            "border_editor": border_editor,
            "shadow_editor": shadow_editor,
            "outline_editor": outline_editor,
        }

        legacy_module_map: dict[str, Any] = {
            "selector": skins_selector,
            "preset": skins_preset,
            "editor": skins_editor,
            "preview": skins_preview,
            "apply": skins_apply,
            "clear": skins_clear,
            "token_mapper": skins_token_mapper,
        }
        for key, value in legacy_module_map.items():
            if value is not None and module_map.get(key) is None:
                module_map[key] = value

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, value in modules.items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in SKINS_MODULES and value is not None:
                    merged_modules[normalized] = value
        for key, value in module_map.items():
            if value is not None:
                merged_modules[key] = value

        merged = merge_props(
            props,
            schema_version=int(schema_version),
            module=_normalize_module(module),
            state=_normalize_state(state),
            custom_layout=custom_layout,
            skins=skins,
            selected_skin=selected_skin,
            presets=presets,
            value=value,
            enabled=enabled,
            events=_normalize_events(events),
            modules=merged_modules,
            **merged_modules,
            **kwargs,
        )
        self._normalize_legacy_props(merged)
        self._strict_contract = strict
        self._validate_props(merged, strict=strict)
        super().__init__(*children, props=merged, style=style, strict=strict)

    @staticmethod
    def _normalize_legacy_props(props: dict[str, Any]) -> None:
        modules = dict(props.get("modules") or {})
        changed = False
        for legacy_key, canonical_key in SKINS_MODULE_ALIASES.items():
            if legacy_key in props and canonical_key not in props:
                props[canonical_key] = props[legacy_key]
                changed = True
            if legacy_key in modules and canonical_key not in modules:
                modules[canonical_key] = modules[legacy_key]
                changed = True
        if changed:
            props["modules"] = modules

    @staticmethod
    def _validate_props(props: Mapping[str, Any], *, strict: bool) -> None:
        try:
            ensure_valid_props("skins", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise ValueError("\n".join(exc.errors)) from exc

    def set_module(self, session: Any, module: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        normalized = _normalize_module(module)
        if normalized is None or normalized not in SKINS_MODULES:
            return {"ok": False, "error": f"Unknown skins module '{module}'"}
        payload_dict = dict(payload or {})
        self.props["module"] = normalized
        modules = dict(self.props.get("modules") or {})
        modules[normalized] = payload_dict
        self.props["modules"] = modules
        self.props[normalized] = payload_dict
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_module", {"module": normalized, "payload": payload_dict})

    def update_module(self, session: Any, module: str, **payload: Any) -> dict[str, Any]:
        return self.set_module(session, module, payload)

    def set_state(self, session: Any, state: str) -> dict[str, Any]:
        normalized = _normalize_state(state)
        if normalized is None or normalized not in SKINS_STATES:
            return {"ok": False, "error": f"Unknown skins state '{state}'"}
        self.props["state"] = normalized
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_state", {"state": normalized})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

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
                if normalized and normalized in SKINS_MODULES and value is not None:
                    normalized_modules[normalized] = value
            props["modules"] = normalized_modules
            self._normalize_legacy_props(props)
        next_props = dict(self.props)
        next_props.update({k: v for k, v in props.items() if v is not None})
        self._validate_props(next_props, strict=self._strict_contract)
        self.props.update({k: v for k, v in props.items() if v is not None})
        return self.invoke(session, "set_props", {"props": props})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        event_name = _normalize_token(event)
        event_name = SKINS_EVENT_ALIASES.get(event_name, event_name)
        if event_name not in SKINS_EVENTS:
            return {"ok": False, "error": f"Unknown skins event '{event}'"}
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

    def apply(self, session: Any, skin: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if skin is not None:
            payload["skin"] = skin
        return self.invoke(session, "apply", payload)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def create_skin(self, session: Any, name: str, payload: Any | None = None) -> dict[str, Any]:
        args: dict[str, Any] = {"name": name}
        if payload is not None:
            args["payload"] = payload
        return self.invoke(session, "create_skin", args)

    def edit_skin(self, session: Any, name: str, payload: Any | None = None) -> dict[str, Any]:
        args: dict[str, Any] = {"name": name}
        if payload is not None:
            args["payload"] = payload
        return self.invoke(session, "edit_skin", args)

    def delete_skin(self, session: Any, name: str) -> dict[str, Any]:
        return self.invoke(session, "delete_skin", {"name": name})

    def set_skins(
        self,
        session: Any,
        skins: list[Any],
        *,
        selected_skin: str | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {"skins": skins}
        if selected_skin is not None:
            payload["selected_skin"] = selected_skin
        return self.set_props(session, **payload)

    def set_presets(self, session: Any, presets: list[Any]) -> dict[str, Any]:
        return self.set_props(session, presets=presets)

    def select(self, session: Any, skin: str) -> dict[str, Any]:
        return self.emit(session, "select", {"skin": skin})

    def set_token_mapping(self, session: Any, mapping: Mapping[str, Any]) -> dict[str, Any]:
        return self.set_module(session, "token_mapper", {"mapping": dict(mapping)})
