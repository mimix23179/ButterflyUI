from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "select_all"


class SelectAll(GallerySubmodule):
    """Gallery submodule host control for `select_all`."""

    control_type = "gallery_select_all"
    umbrella = "gallery"
    module_token = MODULE_TOKEN
    canonical_module = MODULE_TOKEN

    module_props = tuple(sorted(MODULE_ALLOWED_KEYS.get(MODULE_TOKEN, set())))
    module_prop_types = dict(MODULE_PAYLOAD_TYPES.get(MODULE_TOKEN, {}))
    supported_events = tuple(MODULE_EVENTS.get(MODULE_TOKEN, ()))
    supported_actions = tuple(MODULE_ACTIONS.get(MODULE_TOKEN, ()))

    def __init__(
        self,
        *children: object,
        payload: Mapping[str, object] | None = None,
        props: Mapping[str, object] | None = None,
        style: Mapping[str, object] | None = None,
        strict: bool = False,
        action: str | None = None,
        actions: list[object] | None = None,
        active_id: str | None = None,
        author: str | None = None,
        badge: str | None = None,
        can_apply: bool | None = None,
        can_clear: bool | None = None,
        can_deselect_all: bool | None = None,
        can_select_all: bool | None = None,
        charsets: list[object] | None = None,
        confirm: bool | None = None,
        duration: int | float | None = None,
        font_family: str | None = None,
        font_weight: str | None = None,
        format: str | None = None,
        id: str | None = None,
        max_selected: int | None = None,
        metadata: Mapping[str, object] | None = None,
        mime: str | None = None,
        multi_select: bool | None = None,
        name: str | None = None,
        path: str | None = None,
        preset_id: str | None = None,
        preview_url: str | None = None,
        resolution: str | None = None,
        sample_text: str | None = None,
        selectable: bool | None = None,
        selected_ids: list[object] | None = None,
        selection_mode: str | None = None,
        size: int | None = None,
        skin_id: str | None = None,
        status: str | None = None,
        target: str | None = None,
        target_slot: str | None = None,
        theme: Mapping[str, object] | None = None,
        thumbnail: str | None = None,
        wallpaper_mode: str | None = None,
        weights: list[object] | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if action is not None:
            resolved_payload["action"] = action
        if actions is not None:
            resolved_payload["actions"] = actions
        if active_id is not None:
            resolved_payload["active_id"] = active_id
        if author is not None:
            resolved_payload["author"] = author
        if badge is not None:
            resolved_payload["badge"] = badge
        if can_apply is not None:
            resolved_payload["can_apply"] = can_apply
        if can_clear is not None:
            resolved_payload["can_clear"] = can_clear
        if can_deselect_all is not None:
            resolved_payload["can_deselect_all"] = can_deselect_all
        if can_select_all is not None:
            resolved_payload["can_select_all"] = can_select_all
        if charsets is not None:
            resolved_payload["charsets"] = charsets
        if confirm is not None:
            resolved_payload["confirm"] = confirm
        if duration is not None:
            resolved_payload["duration"] = duration
        if font_family is not None:
            resolved_payload["font_family"] = font_family
        if font_weight is not None:
            resolved_payload["font_weight"] = font_weight
        if format is not None:
            resolved_payload["format"] = format
        if id is not None:
            resolved_payload["id"] = id
        if max_selected is not None:
            resolved_payload["max_selected"] = max_selected
        if metadata is not None:
            resolved_payload["metadata"] = metadata
        if mime is not None:
            resolved_payload["mime"] = mime
        if multi_select is not None:
            resolved_payload["multi_select"] = multi_select
        if name is not None:
            resolved_payload["name"] = name
        if path is not None:
            resolved_payload["path"] = path
        if preset_id is not None:
            resolved_payload["preset_id"] = preset_id
        if preview_url is not None:
            resolved_payload["preview_url"] = preview_url
        if resolution is not None:
            resolved_payload["resolution"] = resolution
        if sample_text is not None:
            resolved_payload["sample_text"] = sample_text
        if selectable is not None:
            resolved_payload["selectable"] = selectable
        if selected_ids is not None:
            resolved_payload["selected_ids"] = selected_ids
        if selection_mode is not None:
            resolved_payload["selection_mode"] = selection_mode
        if size is not None:
            resolved_payload["size"] = size
        if skin_id is not None:
            resolved_payload["skin_id"] = skin_id
        if status is not None:
            resolved_payload["status"] = status
        if target is not None:
            resolved_payload["target"] = target
        if target_slot is not None:
            resolved_payload["target_slot"] = target_slot
        if theme is not None:
            resolved_payload["theme"] = theme
        if thumbnail is not None:
            resolved_payload["thumbnail"] = thumbnail
        if wallpaper_mode is not None:
            resolved_payload["wallpaper_mode"] = wallpaper_mode
        if weights is not None:
            resolved_payload["weights"] = weights
        super().__init__(
            *children,
            payload=resolved_payload,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_module_props(self, session: object, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        update_payload = dict(payload or {})
        if kwargs:
            update_payload.update(kwargs)
        return self.set_payload(session, update_payload)

    def emit_module_event(self, session: object, event: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.emit_event(session, event, payload, **kwargs)

    def run_module_action(self, session: object, action: str, payload: Mapping[str, object] | None = None, **kwargs: object) -> dict[str, object]:
        return self.run_action(session, action, payload, **kwargs)

    def contract(self) -> dict[str, object]:
        return self.describe_contract()


__all__ = ["SelectAll"]
