from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Router"]

class Router(Component):
    control_type = "router"

    def __init__(
        self,
        *children: Any,
        routes: list[Mapping[str, Any]] | None = None,
        active: str | None = None,
        index: int | None = None,
        transition: Mapping[str, Any] | None = None,
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        keep_alive: bool | None = None,
        lightweight_transitions: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            routes=routes,
            active=active,
            index=index,
            transition=transition,
            source_rect=source_rect,
            keep_alive=keep_alive,
            lightweight_transitions=lightweight_transitions,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def to_json(self) -> dict[str, Any]:
        payload = super().to_json()
        props = payload.get("props")
        if not isinstance(props, dict):
            return payload

        keep_alive = props.get("keep_alive") is True
        if keep_alive:
            return payload

        children = payload.get("children")
        if not isinstance(children, list) or not children:
            return payload

        active = props.get("active")
        active_id = str(active) if active is not None else None
        active_index_raw = props.get("index")
        active_index = active_index_raw if isinstance(active_index_raw, int) else None

        for index, child in enumerate(children):
            if not isinstance(child, dict):
                continue
            control_type = str(child.get("type") or "").lower()
            if control_type not in {"route_view", "route_host", "route"}:
                continue

            child_props = child.get("props")
            if not isinstance(child_props, dict):
                child_props = {}
                child["props"] = child_props

            route_id_raw = (
                child_props.get("route_id")
                or child_props.get("id")
                or child.get("id")
            )
            route_id = str(route_id_raw) if route_id_raw is not None else ""

            is_active = False
            if active_id is not None:
                is_active = route_id == active_id
            elif active_index is not None:
                is_active = index == active_index
            elif index == 0:
                is_active = True

            if is_active:
                continue

            child["children"] = []
            for key in ("child", "content", "children"):
                if key in child_props:
                    child_props.pop(key, None)

        return payload
