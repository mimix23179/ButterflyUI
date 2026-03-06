from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["DataTable"]

@butterfly_control('data_table', field_aliases={'controls': 'children'})
class DataTable(ScrollableControl, MultiChildControl):
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
    """

    columns: list[Any] | None = None
    """
    Column definitions — a list of mapping objects with ``"id"``, ``"label"``, and optional ``"numeric"`` keys, or plain strings used as both id and label.
    """

    rows: list[Any] | None = None
    """
    Row data items — lists of cell values, mapping objects keyed by column ``id``, or objects containing a ``"cells"`` list.
    """

    sortable: bool | None = None
    """
    Controls whether (default), column headers are tappable for sorting. Emits ``"sort_change"`` with the column id and direction. Set it to ``False`` to disable this behavior.
    """

    filterable: bool | None = None
    """
    If ``True``, a search ``TextField`` appears above the table for live case-insensitive row filtering.
    """

    selectable: bool | None = None
    """
    If ``True``, each row gets a leading checkbox and emits ``"row_select"`` events.
    """

    dense: bool | None = None
    """
    If ``True``, rows use compact height (32–40 lp) and tighter column spacing.
    """

    striped: bool | None = None
    """
    If ``True``, odd rows receive a semi-transparent surface highlight for visual separation.
    """

    show_header: bool | None = None
    """
    Controls whether (default), the column header row is rendered. Set to ``False`` to hide headers. Set it to ``False`` to disable this behavior.
    """

    sort_column: str | None = None
    """
    Initial column ``id`` by which the table is sorted.
    """

    sort_ascending: bool | None = None
    """
    Controls whether (default), the initial sort direction is ascending. Set it to ``False`` to disable this behavior.
    """

    filter_query: str | None = None
    """
    Initial text pre-filled in the filter ``TextField``.
    """

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
