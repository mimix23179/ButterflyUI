from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "grid_layout"


class GridLayout(GallerySubmodule):
    """Gallery submodule host control for `grid_layout`."""

    control_type = "gallery_grid_layout"
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
        adaptive: bool | None = None,
        cache_key: str | None = None,
        cache_policy: str | None = None,
        can_apply: bool | None = None,
        can_clear: bool | None = None,
        can_deselect_all: bool | None = None,
        can_select_all: bool | None = None,
        columns: int | None = None,
        confirm: bool | None = None,
        count: int | None = None,
        dataset_id: str | None = None,
        error: str | None = None,
        has_more: bool | None = None,
        items: list[object] | None = None,
        loading: bool | None = None,
        max_columns: int | None = None,
        min_columns: int | None = None,
        row_height: int | float | str | None = None,
        run_spacing: int | float | None = None,
        source: str | None = None,
        sources: list[object] | None = None,
        spacing: int | float | None = None,
        target: str | None = None,
        target_slot: str | None = None,
        tile_height: int | float | str | None = None,
        tile_width: int | float | str | None = None,
        total: int | None = None,
        view_mode: str | None = None,
        virtualized: bool | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if action is not None:
            resolved_payload["action"] = action
        if actions is not None:
            resolved_payload["actions"] = actions
        if adaptive is not None:
            resolved_payload["adaptive"] = adaptive
        if cache_key is not None:
            resolved_payload["cache_key"] = cache_key
        if cache_policy is not None:
            resolved_payload["cache_policy"] = cache_policy
        if can_apply is not None:
            resolved_payload["can_apply"] = can_apply
        if can_clear is not None:
            resolved_payload["can_clear"] = can_clear
        if can_deselect_all is not None:
            resolved_payload["can_deselect_all"] = can_deselect_all
        if can_select_all is not None:
            resolved_payload["can_select_all"] = can_select_all
        if columns is not None:
            resolved_payload["columns"] = columns
        if confirm is not None:
            resolved_payload["confirm"] = confirm
        if count is not None:
            resolved_payload["count"] = count
        if dataset_id is not None:
            resolved_payload["dataset_id"] = dataset_id
        if error is not None:
            resolved_payload["error"] = error
        if has_more is not None:
            resolved_payload["has_more"] = has_more
        if items is not None:
            resolved_payload["items"] = items
        if loading is not None:
            resolved_payload["loading"] = loading
        if max_columns is not None:
            resolved_payload["max_columns"] = max_columns
        if min_columns is not None:
            resolved_payload["min_columns"] = min_columns
        if row_height is not None:
            resolved_payload["row_height"] = row_height
        if run_spacing is not None:
            resolved_payload["run_spacing"] = run_spacing
        if source is not None:
            resolved_payload["source"] = source
        if sources is not None:
            resolved_payload["sources"] = sources
        if spacing is not None:
            resolved_payload["spacing"] = spacing
        if target is not None:
            resolved_payload["target"] = target
        if target_slot is not None:
            resolved_payload["target_slot"] = target_slot
        if tile_height is not None:
            resolved_payload["tile_height"] = tile_height
        if tile_width is not None:
            resolved_payload["tile_width"] = tile_width
        if total is not None:
            resolved_payload["total"] = total
        if view_mode is not None:
            resolved_payload["view_mode"] = view_mode
        if virtualized is not None:
            resolved_payload["virtualized"] = virtualized
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


__all__ = ["GridLayout"]
