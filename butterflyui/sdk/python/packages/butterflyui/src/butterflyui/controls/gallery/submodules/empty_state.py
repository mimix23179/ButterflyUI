from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "empty_state"


class EmptyState(GallerySubmodule):
    """Gallery submodule host control for `empty_state`."""

    control_type = "gallery_empty_state"
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
        can_apply: bool | None = None,
        can_clear: bool | None = None,
        can_deselect_all: bool | None = None,
        can_select_all: bool | None = None,
        confirm: bool | None = None,
        cta_action: str | None = None,
        cta_label: str | None = None,
        debounce_ms: int | None = None,
        empty_hint: str | None = None,
        empty_message: str | None = None,
        filters: Mapping[str, object] | None = None,
        group_by: str | None = None,
        placeholder: str | None = None,
        query: str | None = None,
        retry_label: str | None = None,
        skeleton_count: int | None = None,
        sort_by: str | None = None,
        sort_dir: str | None = None,
        target: str | None = None,
        target_slot: str | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if action is not None:
            resolved_payload["action"] = action
        if actions is not None:
            resolved_payload["actions"] = actions
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
        if cta_action is not None:
            resolved_payload["cta_action"] = cta_action
        if cta_label is not None:
            resolved_payload["cta_label"] = cta_label
        if debounce_ms is not None:
            resolved_payload["debounce_ms"] = debounce_ms
        if empty_hint is not None:
            resolved_payload["empty_hint"] = empty_hint
        if empty_message is not None:
            resolved_payload["empty_message"] = empty_message
        if filters is not None:
            resolved_payload["filters"] = filters
        if group_by is not None:
            resolved_payload["group_by"] = group_by
        if placeholder is not None:
            resolved_payload["placeholder"] = placeholder
        if query is not None:
            resolved_payload["query"] = query
        if retry_label is not None:
            resolved_payload["retry_label"] = retry_label
        if skeleton_count is not None:
            resolved_payload["skeleton_count"] = skeleton_count
        if sort_by is not None:
            resolved_payload["sort_by"] = sort_by
        if sort_dir is not None:
            resolved_payload["sort_dir"] = sort_dir
        if target is not None:
            resolved_payload["target"] = target
        if target_slot is not None:
            resolved_payload["target_slot"] = target_slot
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


__all__ = ["EmptyState"]
