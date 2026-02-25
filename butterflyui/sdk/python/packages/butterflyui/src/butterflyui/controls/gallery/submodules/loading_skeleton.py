from __future__ import annotations

from collections.abc import Mapping
from typing import Iterable

from .control import GallerySubmodule
from .schema import MODULE_ACTIONS, MODULE_ALLOWED_KEYS, MODULE_EVENTS, MODULE_PAYLOAD_TYPES

MODULE_TOKEN = "loading_skeleton"


class LoadingSkeleton(GallerySubmodule):
    """Gallery submodule host control for `loading_skeleton`."""

    control_type = "gallery_loading_skeleton"
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
        adaptive: bool | None = None,
        animated: bool | None = None,
        cache_key: str | None = None,
        cache_policy: str | None = None,
        columns: int | None = None,
        count: int | None = None,
        dataset_id: str | None = None,
        empty_hint: str | None = None,
        empty_message: str | None = None,
        error: str | None = None,
        has_more: bool | None = None,
        items: list[object] | None = None,
        loading: bool | None = None,
        retry_label: str | None = None,
        row_height: int | float | str | None = None,
        run_spacing: int | float | None = None,
        skeleton_count: int | None = None,
        source: str | None = None,
        sources: list[object] | None = None,
        spacing: int | float | None = None,
        tile_height: int | float | str | None = None,
        tile_width: int | float | str | None = None,
        total: int | None = None,
        view_mode: str | None = None,
        virtualized: bool | None = None,
        **kwargs: object,
    ) -> None:
        resolved_payload = dict(payload or {})
        if adaptive is not None:
            resolved_payload["adaptive"] = adaptive
        if animated is not None:
            resolved_payload["animated"] = animated
        if cache_key is not None:
            resolved_payload["cache_key"] = cache_key
        if cache_policy is not None:
            resolved_payload["cache_policy"] = cache_policy
        if columns is not None:
            resolved_payload["columns"] = columns
        if count is not None:
            resolved_payload["count"] = count
        if dataset_id is not None:
            resolved_payload["dataset_id"] = dataset_id
        if empty_hint is not None:
            resolved_payload["empty_hint"] = empty_hint
        if empty_message is not None:
            resolved_payload["empty_message"] = empty_message
        if error is not None:
            resolved_payload["error"] = error
        if has_more is not None:
            resolved_payload["has_more"] = has_more
        if items is not None:
            resolved_payload["items"] = items
        if loading is not None:
            resolved_payload["loading"] = loading
        if retry_label is not None:
            resolved_payload["retry_label"] = retry_label
        if row_height is not None:
            resolved_payload["row_height"] = row_height
        if run_spacing is not None:
            resolved_payload["run_spacing"] = run_spacing
        if skeleton_count is not None:
            resolved_payload["skeleton_count"] = skeleton_count
        if source is not None:
            resolved_payload["source"] = source
        if sources is not None:
            resolved_payload["sources"] = sources
        if spacing is not None:
            resolved_payload["spacing"] = spacing
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


__all__ = ["LoadingSkeleton"]
