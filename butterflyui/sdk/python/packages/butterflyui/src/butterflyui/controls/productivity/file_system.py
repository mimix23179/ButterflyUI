from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["FileSystem"]

class FileSystem(Component):
    """
    Interactive file-system browser backed by a virtual or real directory tree.

    The runtime renders a tree-style file browser. ``root`` sets the root
    directory path. ``nodes`` provides a pre-built virtual tree. ``selected_path``
    marks the initially selected path. ``show_hidden`` toggles hidden files.
    ``readonly`` disables file-system mutations.

    ```python
    import butterflyui as bui

    bui.FileSystem(
        root="/home/user/project",
        show_hidden=False,
        readonly=True,
        events=["select", "open"],
    )
    ```

    Args:
        root:
            Absolute root directory path displayed at the top of the tree.
        nodes:
            Pre-built virtual tree node list (id, label, children, etc.).
        selected_path:
            Initially selected file or directory path.
        show_hidden:
            When ``True`` hidden files and directories are shown.
        readonly:
            When ``True`` file-system write operations are disabled.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "file_system"

    def __init__(
        self,
        *,
        root: str | None = None,
        nodes: list[dict[str, Any]] | None = None,
        selected_path: str | None = None,
        show_hidden: bool | None = None,
        readonly: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            root=root,
            nodes=nodes,
            selected_path=selected_path,
            show_hidden=show_hidden,
            readonly=readonly,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected_path(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected_path", {"path": path})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
