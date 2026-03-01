from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["StatusBar"]

class StatusBar(Component):
    """
    Horizontal status bar displayed at the bottom of an application window.

    The runtime renders a fixed-height bar at the bottom edge. ``items``
    supply labelled status segments (left or right aligned). ``text`` sets
    a single plain-text message when a full item list is not needed.
    ``dense`` reduces bar height.

    ```python
    import butterflyui as bui

    bui.StatusBar(
        items=[
            {"id": "branch", "label": "main", "icon": "branch"},
            {"id": "errors", "label": "0 errors", "align": "right"},
        ],
    )
    ```

    Args:
        items:
            List of status segment spec mappings.
        text:
            Simple plain-text status message (used instead of ``items``).
        dense:
            Reduces bar height and item padding.
    """

    control_type = "status_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        text: str | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            text=text,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
