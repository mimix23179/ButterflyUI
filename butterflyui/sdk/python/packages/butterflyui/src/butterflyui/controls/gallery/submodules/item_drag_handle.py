from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "item_drag_handle"


class ItemDragHandle(GallerySubmodule):
    """Gallery submodule host control for `item_drag_handle`."""

    control_type = "gallery_item_drag_handle"
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
        confirm: bool | None = None,
        drag_group: str | None = None,
        drag_id: str | None = None,
        draggable: bool | None = None,
        drop_id: str | None = None,
        droppable: bool | None = None,
        duration: int | float | None = None,
        format: str | None = None,
        id: str | None = None,
        index: int | None = None,
        max_selected: int | None = None,
        metadata: Mapping[str, object] | None = None,
        mime: str | None = None,
        multi_select: bool | None = None,
        name: str | None = None,
        path: str | None = None,
        preview_url: str | None = None,
        reorderable: bool | None = None,
        resolution: str | None = None,
        selectable: bool | None = None,
        selected_ids: list[object] | None = None,
        selection_mode: str | None = None,
        size: int | None = None,
        status: str | None = None,
        target: str | None = None,
        target_slot: str | None = None,
        thumbnail: str | None = None,
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
        if confirm is not None:
            resolved_payload["confirm"] = confirm
        if drag_group is not None:
            resolved_payload["drag_group"] = drag_group
        if drag_id is not None:
            resolved_payload["drag_id"] = drag_id
        if draggable is not None:
            resolved_payload["draggable"] = draggable
        if drop_id is not None:
            resolved_payload["drop_id"] = drop_id
        if droppable is not None:
            resolved_payload["droppable"] = droppable
        if duration is not None:
            resolved_payload["duration"] = duration
        if format is not None:
            resolved_payload["format"] = format
        if id is not None:
            resolved_payload["id"] = id
        if index is not None:
            resolved_payload["index"] = index
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
        if preview_url is not None:
            resolved_payload["preview_url"] = preview_url
        if reorderable is not None:
            resolved_payload["reorderable"] = reorderable
        if resolution is not None:
            resolved_payload["resolution"] = resolution
        if selectable is not None:
            resolved_payload["selectable"] = selectable
        if selected_ids is not None:
            resolved_payload["selected_ids"] = selected_ids
        if selection_mode is not None:
            resolved_payload["selection_mode"] = selection_mode
        if size is not None:
            resolved_payload["size"] = size
        if status is not None:
            resolved_payload["status"] = status
        if target is not None:
            resolved_payload["target"] = target
        if target_slot is not None:
            resolved_payload["target_slot"] = target_slot
        if thumbnail is not None:
            resolved_payload["thumbnail"] = thumbnail
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


__all__ = ["ItemDragHandle"]
