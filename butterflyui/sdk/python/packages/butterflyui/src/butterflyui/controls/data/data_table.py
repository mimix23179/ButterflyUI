from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DataTable"]

class DataTable(Component):
    """
    Feature-rich tabular data view with column sorting, row filtering,
    checkbox selection, and striped-row styling.

    The runtime renders a Flutter ``DataTable`` wrapped in horizontal and
    vertical ``SingleChildScrollView`` widgets for overflow scrolling.
    Columns are parsed from mapping objects (keys ``id``/``label``/
    ``numeric``) or plain strings.  Rows accept lists of cell values,
    mapping objects keyed by column ``id``, or objects with a ``cells``
    list.  When ``filterable`` is ``True`` a ``TextField`` is displayed
    above the table for live row filtering across all cells.  Tapping a
    sortable header emits ``"sort_change"``; toggling a row checkbox
    emits ``"row_select"``; tapping a cell emits ``"row_tap"``;
    typing in the filter field emits ``"filter_change"``.

    ```python
    import butterflyui as bui

    bui.DataTable(
        columns=[
            {"id": "name", "label": "Name"},
            {"id": "score", "label": "Score", "numeric": True},
        ],
        rows=[
            {"name": "Alice", "score": 95},
            {"name": "Bob", "score": 82},
        ],
        sortable=True,
        filterable=True,
        selectable=True,
        striped=True,
    )
    ```

    Args:
        columns: 
            Column definitions — a list of mapping objects with ``"id"``, ``"label"``, and optional ``"numeric"`` keys, or plain strings used as both id and label.
        rows: 
            Row data items — lists of cell values, mapping objects keyed by column ``id``, or objects containing a ``"cells"`` list.
        sortable: 
            If ``True`` (default), column headers are tappable for sorting.  Emits ``"sort_change"`` with the column id and direction.
        filterable: 
            If ``True``, a search ``TextField`` appears above the table for live case-insensitive row filtering.
        selectable: 
            If ``True``, each row gets a leading checkbox and emits ``"row_select"`` events.
        dense: 
            If ``True``, rows use compact height (32–40 lp) and tighter column spacing.
        striped: 
            If ``True``, odd rows receive a semi-transparent surface highlight for visual separation.
        show_header: 
            If ``True`` (default), the column header row is rendered.  Set to ``False`` to hide headers.
        sort_column: 
            Initial column ``id`` by which the table is sorted.
        sort_ascending: 
            If ``True`` (default), the initial sort direction is ascending.
        filter_query: 
            Initial text pre-filled in the filter ``TextField``.
    """

    control_type = "data_table"

    def __init__(
        self,
        *,
        columns: list[Any] | None = None,
        rows: list[Any] | None = None,
        sortable: bool | None = None,
        filterable: bool | None = None,
        selectable: bool | None = None,
        dense: bool | None = None,
        striped: bool | None = None,
        show_header: bool | None = None,
        sort_column: str | None = None,
        sort_ascending: bool | None = None,
        filter_query: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            columns=columns,
            rows=rows,
            sortable=sortable,
            filterable=filterable,
            selectable=selectable,
            dense=dense,
            striped=striped,
            show_header=show_header,
            sort_column=sort_column,
            sort_ascending=sort_ascending,
            filter_query=filter_query,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_sort(
        self,
        session: Any,
        *,
        column: str | None = None,
        ascending: bool = True,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_sort",
            {"column": column, "ascending": ascending},
        )

    def clear_sort(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_sort", {})

    def set_filter(self, session: Any, query: str) -> dict[str, Any]:
        return self.invoke(session, "set_filter", {"query": query})

    def clear_filter(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_filter", {})

    def clear_selection(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_selection", {})
