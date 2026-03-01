from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TreeView"]

class TreeView(Component):
    """
    Hierarchical tree view with expansion and selection state, supporting
    single or multi-select.

    The runtime recursively renders ``nodes`` as indented rows with
    expand/collapse chevrons for nodes that have children.  Clicking a
    chevron toggles expansion and emits ``"toggle"``; tapping a node
    row emits ``"select"`` with the node ``id`` and payload.  When
    ``multi_select`` is ``True`` multiple nodes can be selected
    simultaneously.  Setting ``expand_all`` causes every node to start
    in the expanded state.  ``show_root`` controls whether the
    top-level nodes themselves are rendered or only their children.

    ```python
    import butterflyui as bui

    bui.TreeView(
        nodes=[
            {"id": "root", "label": "Project", "children": [
                {"id": "src", "label": "src/", "children": [
                    {"id": "main", "label": "main.py"},
                ]},
                {"id": "readme", "label": "README.md"},
            ]},
        ],
        expanded=["root", "src"],
        multi_select=False,
    )
    ```

    Args:
        nodes: 
            Tree node payload list.  Each mapping should carry ``"id"``, ``"label"`` (or ``"title"``), and optional ``"children"`` for nesting.
        expanded: 
            List of node ``id`` strings whose children start visible (expanded).
        selected: 
            Currently selected node ``id``(s) — a single string or list of strings.
        multi_select: 
            If ``True``, multiple nodes can be selected at the same time.
        show_root: 
            If ``True`` (default implied), root-level nodes are rendered.  When ``False`` only their children appear.
        expand_all: 
            If ``True``, every node starts in the expanded state regardless of ``expanded``.
    """

    control_type = "tree_view"

    def __init__(
        self,
        *,
        nodes: list[Any] | None = None,
        expanded: list[str] | None = None,
        selected: list[str] | str | None = None,
        multi_select: bool | None = None,
        show_root: bool | None = None,
        expand_all: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=nodes,
            expanded=expanded,
            selected=selected,
            multi_select=multi_select,
            show_root=show_root,
            expand_all=expand_all,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
