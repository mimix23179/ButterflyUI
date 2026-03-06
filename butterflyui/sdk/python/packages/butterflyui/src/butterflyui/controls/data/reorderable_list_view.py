from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..items_control import ItemsControl
__all__ = ["ReorderableListView"]

@butterfly_control('reorderable_list_view')
class ReorderableListView(ScrollableControl, ItemsControl):
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
    """

    dense: bool | None = None
    """
    If ``True``, uses compact row spacing.
    """

    def set_items(self, session: Any, items: Sequence[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": list(items)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
