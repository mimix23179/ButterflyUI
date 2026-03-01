from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ReorderableTree"]

class ReorderableTree(Component):
    """
    Drag-and-drop reorderable tree list backed by Flutter’s
    ``ReorderableListView``.

    Each node mapping is rendered as a ``ListTile`` indented by its
    ``depth`` value, with ``label`` (or ``title``/``name``) text and a
    drag-handle icon.  Dragging a node to a new position emits a
    ``"reorder"`` event carrying ``from``, ``to``, and the updated
    ``nodes`` list.  Tapping a node emits ``"select"`` with the node
    ``id``, ``index``, and full ``node`` payload.  Use ``set_nodes()``
    to replace the node list programmatically.

    ```python
    import butterflyui as bui

    bui.ReorderableTree(
        nodes=[
            {"id": "root", "label": "Root", "depth": 0},
            {"id": "child-1", "label": "Child 1", "depth": 1},
            {"id": "child-2", "label": "Child 2", "depth": 1},
        ],
        dense=False,
    )
    ```

    Args:
        nodes: 
            Flat node payload list.  Each mapping should contain ``"id"``, ``"label"`` (or ``"title"``/``"name"``), and ``"depth"`` (integer indentation level).
        expanded: 
            List of node ``id`` strings whose children are visually expanded.
        selected: 
            List of currently selected node ``id`` strings.
        dense: 
            If ``True``, list tiles use compact vertical density.
        lock_axis: 
            Restricts drag movement to a single axis (e.g. ``"vertical"``).
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "reorderable_tree"

    def __init__(
        self,
        *children: Any,
        nodes: list[Mapping[str, Any]] | None = None,
        expanded: list[str] | None = None,
        selected: list[str] | None = None,
        dense: bool | None = None,
        lock_axis: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=[dict(node) for node in (nodes or [])],
            expanded=expanded,
            selected=selected,
            dense=dense,
            lock_axis=lock_axis,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_nodes(self, session: Any, nodes: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_nodes", {"nodes": [dict(node) for node in nodes]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
