from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "filter_bar"


class FilterBar(GallerySubmodule):
    """Gallery submodule host control for `filter_bar`."""

    control_type = "gallery_filter_bar"
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
        active_filters: Mapping[str, object] | None = None,
        active_id: str | None = None,
        cache_key: str | None = None,
        cache_policy: str | None = None,
        count: int | None = None,
        dataset_id: str | None = None,
        debounce_ms: int | None = None,
        error: str | None = None,
        filter_groups: list[object] | None = None,
        filters: Mapping[str, object] | None = None,
        group_by: str | None = None,
        has_more: bool | None = None,
        items: list[object] | None = None,
        loading: bool | None = None,
        max_selected: int | None = None,
        multi_select: bool | None = None,
        placeholder: str | None = None,
        query: str | None = None,
        selectable: bool | None = None,
        selected_ids: list[object] | None = None,
        selection_mode: str | None = None,
        sort_by: str | None = None,
        sort_dir: str | None = None,
        source: str | None = None,
        sources: list[object] | None = None,
        total: int | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if active_filters is not None:
            resolved_payload["active_filters"] = active_filters
        if active_id is not None:
            resolved_payload["active_id"] = active_id
        if cache_key is not None:
            resolved_payload["cache_key"] = cache_key
        if cache_policy is not None:
            resolved_payload["cache_policy"] = cache_policy
        if count is not None:
            resolved_payload["count"] = count
        if dataset_id is not None:
            resolved_payload["dataset_id"] = dataset_id
        if debounce_ms is not None:
            resolved_payload["debounce_ms"] = debounce_ms
        if error is not None:
            resolved_payload["error"] = error
        if filter_groups is not None:
            resolved_payload["filter_groups"] = filter_groups
        if filters is not None:
            resolved_payload["filters"] = filters
        if group_by is not None:
            resolved_payload["group_by"] = group_by
        if has_more is not None:
            resolved_payload["has_more"] = has_more
        if items is not None:
            resolved_payload["items"] = items
        if loading is not None:
            resolved_payload["loading"] = loading
        if max_selected is not None:
            resolved_payload["max_selected"] = max_selected
        if multi_select is not None:
            resolved_payload["multi_select"] = multi_select
        if placeholder is not None:
            resolved_payload["placeholder"] = placeholder
        if query is not None:
            resolved_payload["query"] = query
        if selectable is not None:
            resolved_payload["selectable"] = selectable
        if selected_ids is not None:
            resolved_payload["selected_ids"] = selected_ids
        if selection_mode is not None:
            resolved_payload["selection_mode"] = selection_mode
        if sort_by is not None:
            resolved_payload["sort_by"] = sort_by
        if sort_dir is not None:
            resolved_payload["sort_dir"] = sort_dir
        if source is not None:
            resolved_payload["source"] = source
        if sources is not None:
            resolved_payload["sources"] = sources
        if total is not None:
            resolved_payload["total"] = total
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


__all__ = ["FilterBar"]
