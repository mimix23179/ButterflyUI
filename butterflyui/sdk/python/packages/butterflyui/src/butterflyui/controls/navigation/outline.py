from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Outline"]

class Outline(Component):
    """
    Expandable tree outline panel for hierarchical navigation.

    The runtime renders a collapsible tree of nodes. ``nodes`` supplies the
    hierarchy, where each node may have a ``children`` list. ``expanded`` is
    a list of node IDs that are currently open. ``selected_id`` highlights
    the active node. ``dense`` reduces row height; ``show_icons`` controls
    icon visibility.

    ```python
    import butterflyui as bui

    bui.Outline(
        nodes=[
            {"id": "src", "label": "src", "children": [
                {"id": "main", "label": "main.py"},
            ]},
        ],
        expanded=["src"],
        events=["select", "expand"],
    )
    ```

    Args:
        nodes:
            List of tree node spec mappings. Nodes may include ``id``,
            ``label``, ``icon``, and ``children``.
        expanded:
            List of node IDs whose subtrees are currently expanded.
        selected_id:
            The ``id`` of the currently selected node.
        dense:
            Reduces row height and indent padding.
        show_icons:
            When ``True`` icon decorations are shown beside node labels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "outline"

    def __init__(
        self,
        *,
        nodes: list[Mapping[str, Any]] | None = None,
        expanded: list[str] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        show_icons: bool | None = None,
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
            selected_id=selected_id,
            dense=dense,
            show_icons=show_icons,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
