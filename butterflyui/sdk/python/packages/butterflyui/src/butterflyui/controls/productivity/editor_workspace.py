from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["EditorWorkspace"]

class EditorWorkspace(Component):
    control_type = "editor_workspace"

    def __init__(
        self,
        *,
        documents: list[dict[str, Any]] | None = None,
        active_id: str | None = None,
        workspace_nodes: list[dict[str, Any]] | None = None,
        problems: list[dict[str, Any]] | None = None,
        show_explorer: bool | None = None,
        show_problems: bool | None = None,
        show_status_bar: bool | None = None,
        status_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            documents=documents,
            active_id=active_id,
            workspace_nodes=workspace_nodes,
            problems=problems,
            show_explorer=show_explorer,
            show_problems=show_problems,
            show_status_bar=show_status_bar,
            status_text=status_text,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
