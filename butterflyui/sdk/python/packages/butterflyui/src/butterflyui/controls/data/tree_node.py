from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TreeNode"]

class TreeNode(Component):
    """
    Descriptor for a single node inside a tree-based control such as
    ``TreeView`` or ``FileBrowser``.

    ``TreeNode`` does not render on its own; instead it serialises node
    metadata (``node_id``, ``label``, ``icon``, expansion/selection/
    disabled state, and nested ``children``) into the JSON payload
    consumed by tree renderers.  The ``node_id`` is forwarded as the
    ``"id"`` prop.

    ```python
    import butterflyui as bui

    bui.TreeNode(
        node_id="folder-1",
        label="Documents",
        icon="folder",
        expanded=True,
        children=[
            bui.TreeNode(node_id="file-1", label="notes.txt", icon="description"),
        ],
    )
    ```

    Args:
        node_id: 
            Stable unique identifier for this node, serialised as ``"id"`` in the runtime payload.
        label: 
            Display label text rendered next to the node icon.
        icon: 
            Optional icon name or data associated with the node.
        expanded: 
            If ``True``, the node’s children are visible (expanded) initially.
        selected: 
            If ``True``, the node is rendered in its selected visual state.
        disabled: 
            If ``True``, the node is non-interactive and visually dimmed.
    """

    control_type = "tree_node"

    def __init__(
        self,
        *,
        node_id: str | None = None,
        label: str | None = None,
        icon: str | None = None,
        expanded: bool | None = None,
        selected: bool | None = None,
        disabled: bool | None = None,
        children: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            id=node_id,
            label=label,
            icon=icon,
            expanded=expanded,
            selected=selected,
            disabled=disabled,
            children=children,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
