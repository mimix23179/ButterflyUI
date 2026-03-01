from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["FileSystem"]

class FileSystem(Component):
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
