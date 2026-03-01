from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["WorkspaceTree"]

class WorkspaceTree(Component):
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
