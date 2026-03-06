from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["DataGrid"]


class DataGrid(Component):
    """
    Structured data grid with sorting, filtering, paging, and selection.

    ``DataGrid`` is the high-density tabular surface intended for data-heavy
    experiences such as inventory editors, admin dashboards, and asset browsers.
    Compared to lightweight table wrappers, it keeps all table behavior in one
    payload: sorting, filter query state, selectable rows, striped styling, and
    optional header/footer chrome.

    Runtime methods such as :meth:`set_sort`, :meth:`set_filter`, and
    :meth:`clear_selection` let Python handlers update the live widget after it
    has already been rendered.

    ```python
    import butterflyui as bui

    grid = bui.DataGrid(
        columns=[
            {"key": "name", "label": "Name"},
            {"key": "qty", "label": "Qty"},
        ],
        rows=[
            {"name": "Keyboard", "qty": 12},
            {"name": "Mouse", "qty": 8},
        ],
        sortable=True,
        filterable=True,
        selectable=True,
        page_size=25,
        events=["change", "sort", "select"],
    )
    ```

    Args:
        columns:
            Column descriptors consumed by the Flutter renderer.
        rows:
            Row objects rendered by the grid.
        sortable:
            Enables sort affordances in headers.
        filterable:
            Enables built-in query/filter UI behavior.
        selectable:
            Enables row selection state.
        dense:
            Reduces row height and cell spacing for compact layouts.
        striped:
            Alternates row background treatment for readability.
        show_header:
            If ``False``, header row is hidden.
        show_footer:
            If ``True``, footer/status area is rendered.
        page_size:
            Preferred rows-per-page when pagination is enabled by the client.
        sort_column:
            Initial column key to sort by.
        sort_ascending:
            Initial sort direction.
        filter_query:
            Initial query string applied by the renderer.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    columns: Sequence[Any] | None = None
    """
    Column descriptors consumed by the Flutter renderer.
    """

    rows: Sequence[Any] | None = None
    """
    Row objects rendered by the grid.
    """

    sortable: bool | None = None
    """
    Enables sort affordances in headers.
    """

    filterable: bool | None = None
    """
    Enables built-in query/filter UI behavior.
    """

    selectable: bool | None = None
    """
    Enables row selection state.
    """

    dense: bool | None = None
    """
    Reduces row height and cell spacing for compact layouts.
    """

    striped: bool | None = None
    """
    Alternates row background treatment for readability.
    """

    show_header: bool | None = None
    """
    If ``False``, header row is hidden.
    """

    show_footer: bool | None = None
    """
    If ``True``, footer/status area is rendered.
    """

    page_size: int | None = None
    """
    Preferred rows-per-page when pagination is enabled by the client.
    """

    sort_column: str | None = None
    """
    Initial column key to sort by.
    """

    sort_ascending: bool | None = None
    """
    Initial sort direction.
    """

    filter_query: str | None = None
    """
    Initial query string applied by the renderer.
    """

    events: list[str] | None = None
    """
    Event names the Flutter side should emit to Python.
    """

    control_type = "data_grid"

    def __init__(
        self,
        *,
        columns: Sequence[Any] | None = None,
        rows: Sequence[Any] | None = None,
        sortable: bool | None = None,
        filterable: bool | None = None,
        selectable: bool | None = None,
        dense: bool | None = None,
        striped: bool | None = None,
        show_header: bool | None = None,
        show_footer: bool | None = None,
        page_size: int | None = None,
        sort_column: str | None = None,
        sort_ascending: bool | None = None,
        filter_query: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                columns=list(columns) if columns is not None else None,
                rows=list(rows) if rows is not None else None,
                sortable=sortable,
                filterable=filterable,
                selectable=selectable,
                dense=dense,
                striped=striped,
                show_header=show_header,
                show_footer=show_footer,
                page_size=page_size,
                sort_column=sort_column,
                sort_ascending=sort_ascending,
                filter_query=filter_query,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_sort(self, session: Any, column: str, ascending: bool = True) -> dict[str, Any]:
        return self.invoke(session, "set_sort", {"column": column, "ascending": ascending})

    def clear_sort(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_sort", {})

    def set_filter(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "set_filter", {"query": query})

    def clear_filter(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_filter", {})

    def clear_selection(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_selection", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
