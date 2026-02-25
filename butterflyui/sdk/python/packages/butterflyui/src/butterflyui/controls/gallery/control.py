from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["Gallery"]

GALLERY_SCHEMA_VERSION = 2

GALLERY_MODULES = {
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
}

GALLERY_STATES = {"idle", "loading", "empty", "ready", "disabled"}

GALLERY_EVENTS = {
    "change",
    "select",
    "select_change",
    "page_change",
    "sort_change",
    "filter_change",
    "action",
    "apply",
    "clear",
    "select_all",
    "deselect_all",
    "apply_font",
    "apply_image",
    "set_as_wallpaper",
    "pick",
    "drag_handle",
    "drop_target",
    "section_action",
    "font_change",
}

GALLERY_REGISTRY_ROLE_ALIASES = {
    "module": "module_registry",
    "modules": "module_registry",
    "source": "source_registry",
    "sources": "source_registry",
    "type": "type_registry",
    "types": "type_registry",
    "handler": "type_registry",
    "view": "view_registry",
    "views": "view_registry",
    "panel": "panel_registry",
    "panels": "panel_registry",
    "apply": "apply_registry",
    "adapter": "apply_registry",
    "adapters": "apply_registry",
    "command": "command_registry",
    "commands": "command_registry",
    "module_registry": "module_registry",
    "source_registry": "source_registry",
    "type_registry": "type_registry",
    "view_registry": "view_registry",
    "panel_registry": "panel_registry",
    "apply_registry": "apply_registry",
    "command_registry": "command_registry",
}

GALLERY_REGISTRY_MANIFEST_LISTS = {
    "module_registry": "enabled_modules",
    "source_registry": "enabled_sources",
    "type_registry": "enabled_types",
    "view_registry": "enabled_views",
    "panel_registry": "enabled_panels",
    "apply_registry": "enabled_adapters",
    "command_registry": "enabled_commands",
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


def _normalize_registry_role(
    value: str | None,
    aliases: Mapping[str, str],
) -> str | None:
    normalized = _normalize_token(value)
    if not normalized:
        return None
    return aliases.get(normalized, f"{normalized}_registry")


def _register_runtime_module(
    props: dict[str, Any],
    *,
    role: str,
    module_id: str,
    definition: Mapping[str, Any] | None,
) -> dict[str, Any]:
    normalized_role = _normalize_registry_role(role, GALLERY_REGISTRY_ROLE_ALIASES)
    normalized_module = _normalize_module(module_id)
    if normalized_module is None:
        normalized_module = _normalize_token(module_id)
    if not normalized_role or not normalized_module:
        return {"ok": False, "error": "role and module_id are required"}

    registries = dict(props.get("registries") or {})
    role_registry = dict(registries.get(normalized_role) or {})
    role_registry[normalized_module] = dict(definition or {})
    registries[normalized_role] = role_registry
    props["registries"] = registries

    manifest = dict(props.get("manifest") or {})
    enabled_modules = _normalize_events(manifest.get("enabled_modules")) or []
    if normalized_module in GALLERY_MODULES and normalized_module not in enabled_modules:
        enabled_modules.append(normalized_module)
    manifest["enabled_modules"] = enabled_modules

    list_key = GALLERY_REGISTRY_MANIFEST_LISTS.get(normalized_role)
    if list_key:
        values = _normalize_events(manifest.get(list_key)) or []
        if normalized_module not in values:
            values.append(normalized_module)
        manifest[list_key] = values
    props["manifest"] = manifest

    if normalized_module in GALLERY_MODULES:
        modules = dict(props.get("modules") or {})
        modules.setdefault(normalized_module, {})
        props["modules"] = modules
        props.setdefault(normalized_module, modules[normalized_module])

    return {
        "ok": True,
        "role": normalized_role,
        "module_id": normalized_module,
        "definition": dict(definition or {}),
    }


class Gallery(Component):
    control_type = "gallery"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        module: str | None = None,
        state: str | None = None,
        custom_layout: bool | None = None,
        layout: str | None = None,
        modules: Mapping[str, Any] | None = None,
        radius: float | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        tile_width: float | None = None,
        tile_height: float | None = None,
        selectable: bool | None = None,
        enabled: bool | None = None,
        events: Iterable[str] | None = None,
        toolbar: Mapping[str, Any] | None = None,
        filter_bar: Mapping[str, Any] | None = None,
        grid_layout: Mapping[str, Any] | None = None,
        item_actions: Mapping[str, Any] | None = None,
        item_badge: Mapping[str, Any] | None = None,
        item_meta_row: Mapping[str, Any] | None = None,
        item_preview: Mapping[str, Any] | None = None,
        item_selectable: Mapping[str, Any] | None = None,
        item_tile: Mapping[str, Any] | None = None,
        pagination: Mapping[str, Any] | None = None,
        section_header: Mapping[str, Any] | None = None,
        sort_bar: Mapping[str, Any] | None = None,
        empty_state: Mapping[str, Any] | None = None,
        loading_skeleton: Mapping[str, Any] | None = None,
        search_bar: Mapping[str, Any] | None = None,
        fonts: Mapping[str, Any] | None = None,
        font_picker: Mapping[str, Any] | None = None,
        font_renderer: Mapping[str, Any] | None = None,
        audio: Mapping[str, Any] | None = None,
        audio_picker: Mapping[str, Any] | None = None,
        audio_renderer: Mapping[str, Any] | None = None,
        video: Mapping[str, Any] | None = None,
        video_picker: Mapping[str, Any] | None = None,
        video_renderer: Mapping[str, Any] | None = None,
        image: Mapping[str, Any] | None = None,
        image_picker: Mapping[str, Any] | None = None,
        image_renderer: Mapping[str, Any] | None = None,
        document: Mapping[str, Any] | None = None,
        document_picker: Mapping[str, Any] | None = None,
        document_renderer: Mapping[str, Any] | None = None,
        item_drag_handle: Mapping[str, Any] | None = None,
        item_drop_target: Mapping[str, Any] | None = None,
        item_reorder_handle: Mapping[str, Any] | None = None,
        item_selection_checkbox: Mapping[str, Any] | None = None,
        item_selection_radio: Mapping[str, Any] | None = None,
        item_selection_switch: Mapping[str, Any] | None = None,
        apply: Mapping[str, Any] | None = None,
        clear: Mapping[str, Any] | None = None,
        select_all: Mapping[str, Any] | None = None,
        deselect_all: Mapping[str, Any] | None = None,
        apply_font: Mapping[str, Any] | None = None,
        apply_image: Mapping[str, Any] | None = None,
        set_as_wallpaper: Mapping[str, Any] | None = None,
        presets: Mapping[str, Any] | None = None,
        skins: Mapping[str, Any] | None = None,
        schema_version: int = GALLERY_SCHEMA_VERSION,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        module_map: dict[str, Any] = {
            "toolbar": toolbar,
            "filter_bar": filter_bar,
            "grid_layout": grid_layout,
            "item_actions": item_actions,
            "item_badge": item_badge,
            "item_meta_row": item_meta_row,
            "item_preview": item_preview,
            "item_selectable": item_selectable,
            "item_tile": item_tile,
            "pagination": pagination,
            "section_header": section_header,
            "sort_bar": sort_bar,
            "empty_state": empty_state,
            "loading_skeleton": loading_skeleton,
            "search_bar": search_bar,
            "fonts": fonts,
            "font_picker": font_picker,
            "font_renderer": font_renderer,
            "audio": audio,
            "audio_picker": audio_picker,
            "audio_renderer": audio_renderer,
            "video": video,
            "video_picker": video_picker,
            "video_renderer": video_renderer,
            "image": image,
            "image_picker": image_picker,
            "image_renderer": image_renderer,
            "document": document,
            "document_picker": document_picker,
            "document_renderer": document_renderer,
            "item_drag_handle": item_drag_handle,
            "item_drop_target": item_drop_target,
            "item_reorder_handle": item_reorder_handle,
            "item_selection_checkbox": item_selection_checkbox,
            "item_selection_radio": item_selection_radio,
            "item_selection_switch": item_selection_switch,
            "apply": apply,
            "clear": clear,
            "select_all": select_all,
            "deselect_all": deselect_all,
            "apply_font": apply_font,
            "apply_image": apply_image,
            "set_as_wallpaper": set_as_wallpaper,
            "presets": presets,
            "skins": skins,
        }

        merged_modules: dict[str, Any] = {}
        if isinstance(modules, Mapping):
            for key, value in modules.items():
                normalized = _normalize_module(str(key))
                if normalized and normalized in GALLERY_MODULES and value is not None:
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
            layout=layout,
            manifest=dict(kwargs.pop("manifest", {}) or {}),
            registries=dict(kwargs.pop("registries", {}) or {}),
            items=items,
            radius=radius,
            spacing=spacing,
            run_spacing=run_spacing,
            tile_width=tile_width,
            tile_height=tile_height,
            selectable=selectable,
            enabled=enabled,
            events=_normalize_events(events),
            modules=merged_modules,
            **merged_modules,
            **kwargs,
        )
        self._strict_contract = strict
        self._validate_props(merged, strict=strict)
        super().__init__(*children, props=merged, style=style, strict=strict)

    @staticmethod
    def _validate_props(props: Mapping[str, Any], *, strict: bool) -> None:
        try:
            ensure_valid_props("gallery", props, strict=strict)
        except ButterflyUIContractError as exc:
            raise ValueError("\n".join(exc.errors)) from exc

    def set_module(self, session: Any, module: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        normalized = _normalize_module(module)
        if normalized is None or normalized not in GALLERY_MODULES:
            return {"ok": False, "error": f"Unknown gallery module '{module}'"}
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
        if normalized is None or normalized not in GALLERY_STATES:
            return {"ok": False, "error": f"Unknown gallery state '{state}'"}
        self.props["state"] = normalized
        self._validate_props(self.props, strict=self._strict_contract)
        return self.invoke(session, "set_state", {"state": normalized})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_items(self, session: Any, items: list[Any]) -> dict[str, Any]:
        self.props["items"] = items
        return self.invoke(session, "set_items", {"items": items})

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
                if normalized and normalized in GALLERY_MODULES and value is not None:
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

    def register_source(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="source",
            module_id=module_id,
            definition=definition,
        )

    def register_type_handler(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="type",
            module_id=module_id,
            definition=definition,
        )

    def register_type(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_type_handler(
            session,
            module_id=module_id,
            definition=definition,
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

    def register_apply_adapter(
        self,
        session: Any,
        *,
        module_id: str,
        definition: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.register_module(
            session,
            role="apply",
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
        if event_name not in GALLERY_EVENTS:
            return {"ok": False, "error": f"Unknown gallery event '{event}'"}
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

    def apply(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "apply", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def select_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "select_all", {})

    def deselect_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "deselect_all", {})

    def apply_font(self, session: Any, font: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if font is not None:
            payload["font"] = font
        return self.invoke(session, "apply_font", payload)

    def apply_image(self, session: Any, image: Any | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if image is not None:
            payload["image"] = image
        return self.invoke(session, "apply_image", payload)

    def set_as_wallpaper(self, session: Any, value: Any | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if value is not None:
            payload["value"] = value
        return self.invoke(session, "set_as_wallpaper", payload)

