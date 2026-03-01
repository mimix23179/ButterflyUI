from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["WorkspaceTree"]

class WorkspaceTree(Component):
    """
    Tree view of a workspace file structure for an IDE-style file explorer.

    The runtime renders a collapsible tree of workspace nodes. ``nodes``
    provides the root-level node list. Each node spec may include id,
    label, icon, children, and metadata fields.

    ```python
    import butterflyui as bui

    bui.WorkspaceTree(
        nodes=[
            {"id": "src", "label": "src", "children": [
                {"id": "main.py", "label": "main.py"},
            ]},
        ],
    )
    ```

    Args:
        nodes:
            List of root-level tree node spec mappings.
    """

    control_type = "workspace_tree"

    def __init__(
        self,
        *,
        nodes: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, nodes=nodes, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
