from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["EditorWorkspace"]

class EditorWorkspace(Component):
    """
    IDE-style workspace combining a file explorer, editor area, and status bar.

    The runtime renders an integrated workspace surface. ``documents`` lists
    open editor documents; ``active_id`` sets the focused document.
    ``workspace_nodes`` populates the file-explorer tree. ``problems``
    feeds the problems panel. ``show_explorer``, ``show_problems``, and
    ``show_status_bar`` toggle each UI region. ``status_text`` sets the
    status-bar text.

    ```python
    import butterflyui as bui

    bui.EditorWorkspace(
        documents=[{"id": "main.py", "content": "print('hello')"}],
        active_id="main.py",
        show_explorer=True,
        show_status_bar=True,
    )
    ```

    Args:
        documents:
            List of open document specs (id, content, language, etc.).
        active_id:
            ID of the currently active/focused document.
        workspace_nodes:
            File tree node list for the explorer panel.
        problems:
            List of diagnostic problem specs shown in the problems panel.
        show_explorer:
            When ``True`` the file explorer panel is visible.
        show_problems:
            When ``True`` the problems panel is visible.
        show_status_bar:
            When ``True`` the status bar is visible.
        status_text:
            Text displayed in the status bar.
    """

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
