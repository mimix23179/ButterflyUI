from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["HistoryStack"]

class HistoryStack(Component):
    """
    Scrollable list of undo/redo history entries.

    The runtime renders each item as a ``ListTile`` inside a
    ``ListView.builder``. The currently active entry is highlighted via
    `selected_id` or `selected_index`. Tapping an entry emits a
    ``"select"`` event with the item's ``id``, ``index``, and full
    ``item`` map.

    ```python
    import butterflyui as bui

    bui.HistoryStack(
        items=[
            {"id": "1", "label": "Draw line"},
            {"id": "2", "label": "Fill bucket"},
            {"id": "3", "label": "Crop"},
        ],
        selected_id="2",
    )
    ```

    Args:
        items: 
            List of history-entry dicts. Each item may have ``"id"``, ``"label"`` / ``"title"``, and ``"subtitle"`` keys.
        selected_id: 
            ``id`` of the currently active history entry.
        selected_index: 
            Zero-based index of the currently active entry.
        compact: 
            If ``True``, list tiles are rendered in a dense/compact style.
        show_preview: 
            If ``True``, thumbnail previews are shown alongside each entry.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "history_stack"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        selected_index: int | None = None,
        compact: bool | None = None,
        show_preview: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected_id=selected_id,
            selected_index=selected_index,
            compact=compact,
            show_preview=show_preview,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
