from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DataSourceView"]

class DataSourceView(Component):
    """
    Searchable, selectable list of data-source entries with live
    filtering and selection state.

    The runtime builds a ``Column`` containing an optional search
    ``TextField`` (when ``show_search`` is ``True``) and a ``ListView``
    of ``ListTile`` rows rendered from the ``sources`` list.  Each
    source object should carry at least an ``id`` key; ``title``,
    ``label``, and ``subtitle`` are used for display.  Tapping a tile
    emits a ``"select"`` event with the source ``id``, ``index``, and
    full ``source`` payload.  Typing in the search field filters by
    title case-insensitively and emits ``"query_change"``.

    ```python
    import butterflyui as bui

    bui.DataSourceView(
        sources=[
            {"id": "pg", "title": "PostgreSQL", "subtitle": "localhost:5432"},
            {"id": "redis", "title": "Redis", "subtitle": "localhost:6379"},
        ],
        selected_id="pg",
        show_search=True,
        dense=True,
    )
    ```

    Args:
        sources: 
            List of source mapping objects.  Each should contain at least ``"id"``; ``"title"``, ``"label"``, and ``"subtitle"`` keys are used for display.
        selected_id: 
            The ``id`` of the currently highlighted / selected source row.
        query: 
            Initial search-filter text pre-filled in the search field.
        show_search: 
            If ``True``, a ``TextField`` with a search icon is rendered above the list for live filtering.
        dense: 
            If ``True``, list tiles use compact vertical density.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "data_source_view"

    def __init__(
        self,
        *,
        sources: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        query: str | None = None,
        show_search: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sources=sources,
            selected_id=selected_id,
            query=query,
            show_search=show_search,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_sources(self, session: Any, sources: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_sources", {"sources": [dict(source) for source in sources]})

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def set_query(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "set_query", {"query": query})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
