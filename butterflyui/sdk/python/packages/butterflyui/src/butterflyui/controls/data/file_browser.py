from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FileBrowser"]

class FileBrowser(Component):
    """
    Hierarchical file/folder tree browser with expansion, selection, and
    optional multi-select.

    The runtime parses ``nodes`` into a recursive tree of ``_FileNode``
    objects.  Each node should carry an ``id`` (or ``path``), an
    optional ``label``/``title``, and nested ``children`` for
    directories.  Directories are auto-detected from ``is_dir``,
    ``directory``, ``kind=="dir"``, or the presence of children.
    Folder icons use ``Icons.folder_outlined``, files use
    ``Icons.description_outlined``.  Tapping a node emits
    ``"select"``; double-tapping a file emits ``"open"``; toggling a
    folder chevron emits ``"toggle"`` with the updated expanded-id set.
    When ``multi_select`` is ``True``, more than one node can be
    selected at once.

    ```python
    import butterflyui as bui

    bui.FileBrowser(
        nodes=[
            {"id": "src", "label": "src/", "is_dir": True, "children": [
                {"id": "main.py", "label": "main.py"},
                {"id": "utils.py", "label": "utils.py"},
            ]},
            {"id": "README.md", "label": "README.md"},
        ],
        expanded=["src"],
        show_root=True,
        multi_select=False,
    )
    ```

    Args:
        nodes: 
            Recursive tree-node list representing filesystem items.  Each mapping should contain ``"id"`` (or ``"path"``), ``"label"``, and optional ``"children"`` for directories.
        selected: 
            Currently selected node ``id``(s) — a single string or list of strings.
        expanded: 
            List of folder ``id`` strings whose children are visible (expanded).
        show_root: 
            If ``True`` (default), root-level nodes themselves are rendered.  When ``False`` only their children are shown.
        multi_select: 
            If ``True``, multiple nodes can be selected simultaneously; otherwise selection is exclusive.
        dense: 
            If ``True``, node tiles use compact vertical/horizontal padding.
    """

    control_type = "file_browser"

    def __init__(
        self,
        *,
        nodes: list[Any] | None = None,
        selected: list[str] | str | None = None,
        expanded: list[str] | None = None,
        show_root: bool | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            nodes=nodes,
            selected=selected,
            expanded=expanded,
            show_root=show_root,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
