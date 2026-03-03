from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .reorderable_list import ReorderableList

__all__ = ["ReorderableListView"]


class ReorderableListView(ReorderableList):
    """
    Drag-and-drop reorderable list view with runtime reorder/select events.

    ``ReorderableListView`` is a first-class wrapper over ``ReorderableList``
    that serializes as ``control_type="reorderable_list_view"``.  Items are
    rendered as reorderable rows and can emit:
    - ``"reorder"`` with ``from``/``to`` and updated ``items``
    - ``"select"`` when a row is tapped

    Methods such as ``set_items()``, ``get_state()``, and ``emit()`` are
    inherited from ``ReorderableList``.

    ```python
    import butterflyui as bui

    bui.ReorderableListView(
        items=[
            {"id": "todo-1", "title": "Backlog"},
            {"id": "todo-2", "title": "In Progress"},
            {"id": "todo-3", "title": "Done"},
        ],
        events=["reorder", "select"],
    )
    ```

    Args:
        items:
            Sequence of item payload mappings rendered as rows.
        events:
            Runtime event names to emit back to Python.
    """

    control_type = "reorderable_list_view"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any] | Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            items=items,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
