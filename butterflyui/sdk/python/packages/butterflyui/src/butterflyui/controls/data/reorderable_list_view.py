from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ReorderableListView"]


class ReorderableListView(Component):
    """Drag-and-drop reorderable list surface."""

    control_type = "reorderable_list_view"

    def __init__(
        self,
        *,
        items: Sequence[Any] | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                items=list(items) if items is not None else None,
                dense=dense,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_items(self, session: Any, items: Sequence[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": list(items)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
