from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .data_table import DataTable

__all__ = ["DataGrid"]

class DataGrid(DataTable):
    """
    Semantic alias for ``DataTable`` that uses the ``data_grid`` control
    type in JSON payloads.

    All constructor arguments, invoke helpers, and runtime behaviour are
    identical to ``DataTable`` — only the ``control_type`` string
    differs, allowing server-side routing or skin resolution to
    differentiate data-grid layouts from plain data-table layouts.

    ```python
    import butterflyui as bui

    bui.DataGrid(
        columns=[{"id": "name", "label": "Name"}, {"id": "age", "label": "Age", "numeric": True}],
        rows=[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}],
        sortable=True,
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

    control_type = "data_grid"
