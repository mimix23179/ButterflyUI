from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ReorderableListView"]


class ReorderableListView(Component):
    """
    Drag-and-drop list surface with runtime reorder state.

    ``ReorderableListView`` renders an ordered item collection that users can
    rearrange by dragging. Use :meth:`set_items` when the Python side needs to
    replace the current sequence, and subscribe to reorder-related events to
    persist the new order.

    ```python
    import butterflyui as bui

    lst = bui.ReorderableListView(
        items=[
            {"id": "a", "label": "Backlog"},
            {"id": "b", "label": "In Progress"},
            {"id": "c", "label": "Done"},
        ],
        events=["reorder", "change"],
    )
    ```

    Args:
        items:
            Ordered item descriptors rendered by the list.
        dense:
            If ``True``, uses compact row spacing.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """

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
