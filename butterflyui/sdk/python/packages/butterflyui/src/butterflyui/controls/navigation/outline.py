from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Outline"]

@butterfly_control('outline')
class Outline(LayoutControl):
    """
    Expandable tree outline panel for hierarchical navigation.

    The runtime renders a collapsible tree of nodes. ``nodes`` supplies the
    hierarchy, where each node may have a ``children`` list. ``expanded`` is
    a list of node IDs that are currently open. ``selected_id`` highlights
    the active node. ``dense`` reduces row height; ``show_icons`` controls
    icon visibility.

    Example:

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
    """

    nodes: list[Mapping[str, Any]] | None = None
    """
    List of tree node spec mappings. Nodes may include ``id``,
    ``label``, ``icon``, and ``children``.
    """

    expanded: list[str] | None = None
    """
    List of node IDs whose subtrees are currently expanded.
    """

    selected_id: str | None = None
    """
    The ``id`` of the currently selected node.
    """

    dense: bool | None = None
    """
    Reduces row height and indent padding.
    """

    show_icons: bool | None = None
    """
    When ``True`` icon decorations are shown beside node labels.
    """

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
