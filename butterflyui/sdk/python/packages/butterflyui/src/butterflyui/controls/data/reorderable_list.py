from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ReorderableList"]

class ReorderableList(Component):
    """
    Drag-and-drop reorderable list backed by Flutter’s
    ``ReorderableListView``.

    Each item mapping is rendered as a ``ListTile`` with ``title`` (or
    ``label``/``name``), optional ``subtitle``, and a drag-handle icon
    when ``handle`` is ``True`` (default).  Dragging a row to a new
    position emits a ``"reorder"`` event carrying ``from``, ``to``, and
    the updated ``items`` list.  Tapping a row emits ``"select"`` with
    the item ``id``, ``index``, and full ``item`` payload.  Use
    ``set_items()`` to replace the list programmatically.

    ```python
    import butterflyui as bui

    bui.ReorderableList(
        items=[
            {"id": "a", "title": "First"},
            {"id": "b", "title": "Second"},
            {"id": "c", "title": "Third"},
        ],
        handle=True,
        dense=False,
    )
    ```

    Args:
        items: 
            Item payload list.  Each mapping should contain at least ``"id"`` and ``"title"`` (or ``"label"``/``"name"``).  Optional ``"subtitle"`` is also shown.
        dense: 
            If ``True``, list tiles use compact vertical density.
        lock_axis: 
            Restricts drag movement to a single axis (e.g. ``"vertical"``).
        handle: 
            If ``True`` (default), a drag-handle icon is shown as the trailing widget on each row.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "reorderable_list"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        dense: bool | None = None,
        lock_axis: str | None = None,
        handle: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            dense=dense,
            lock_axis=lock_axis,
            handle=handle,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
