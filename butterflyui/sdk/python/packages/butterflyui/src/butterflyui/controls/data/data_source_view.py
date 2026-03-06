from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["DataSourceView"]

@butterfly_control('data_source_view')
class DataSourceView(LayoutControl):
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
    """

    sources: list[Mapping[str, Any]] | None = None
    """
    List of source mapping objects.  Each should contain at least ``"id"``; ``"title"``, ``"label"``, and ``"subtitle"`` keys are used for display.
    """

    selected_id: str | None = None
    """
    The ``id`` of the currently highlighted / selected source row.
    """

    query: str | None = None
    """
    Initial search-filter text pre-filled in the search field.
    """

    show_search: bool | None = None
    """
    If ``True``, a ``TextField`` with a search icon is rendered above the list for live filtering.
    """

    dense: bool | None = None
    """
    If ``True``, list tiles use compact vertical density.
    """

    loading: Any | None = None
    """
    Loading value forwarded to the `data_source_view` runtime control.
    """

    page: Any | None = None
    """
    Page value forwarded to the `data_source_view` runtime control.
    """

    page_size: Any | None = None
    """
    Page size value forwarded to the `data_source_view` runtime control.
    """

    has_more: Any | None = None
    """
    Has more value forwarded to the `data_source_view` runtime control.
    """

    refreshable: Any | None = None
    """
    Refreshable value forwarded to the `data_source_view` runtime control.
    """

    prefetch_threshold: Any | None = None
    """
    Prefetch threshold value forwarded to the `data_source_view` runtime control.
    """

    cache_key: Any | None = None
    """
    Cache key value forwarded to the `data_source_view` runtime control.
    """

    show_content_on_loading: Any | None = None
    """
    Show content on loading value forwarded to the `data_source_view` runtime control.
    """

    overlay_loading: Any | None = None
    """
    Overlay loading value forwarded to the `data_source_view` runtime control.
    """

    empty_view: Any | None = None
    """
    Empty view value forwarded to the `data_source_view` runtime control.
    """

    error_view: Any | None = None
    """
    Error view value forwarded to the `data_source_view` runtime control.
    """

    offline_view: Any | None = None
    """
    Offline view value forwarded to the `data_source_view` runtime control.
    """

    loading_view: Any | None = None
    """
    Loading view value forwarded to the `data_source_view` runtime control.
    """

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
