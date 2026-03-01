from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .data_table import DataTable

__all__ = ["TableView"]

class TableView(DataTable):
    """
    Convenience wrapper around ``DataTable`` that adds an ``events``
    parameter and an ``emit()`` invoke helper.

    All constructor arguments and runtime behaviour are identical to
    ``DataTable`` — sorting, filtering, selection, striped rows, etc.
    The wrapper simply makes it easier to declare event subscriptions
    and emit custom events from Python.

    ```python
    import butterflyui as bui

    bui.TableView(
        columns=[
            {"id": "city", "label": "City"},
            {"id": "pop", "label": "Population", "numeric": True},
        ],
        rows=[
            {"city": "Tokyo", "pop": 13960000},
            {"city": "Berlin", "pop": 3645000},
        ],
        sortable=True,
        filterable=True,
        events=["sort_change", "filter_change"],
    )
    ```

    Args:
        columns: 
            Column definitions — same format as ``DataTable`` (mapping objects or plain strings).
        rows: 
            Row data items — same format as ``DataTable``.
        sortable: 
            If ``True`` (default), column headers are tappable for sorting.
        filterable: 
            If ``True``, a search ``TextField`` appears above the table.
        selectable: 
            If ``True``, each row gets a leading checkbox.
        dense: 
            If ``True``, rows use compact height and spacing.
        striped: 
            If ``True``, odd rows get a semi-transparent background highlight.
        show_header: 
            If ``True`` (default), the column header row is rendered.
        sort_column: 
            Initial sorted column ``id``.
        sort_ascending: 
            If ``True`` (default), the initial sort direction is ascending.
        filter_query: 
            Initial filter ``TextField`` text.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "table_view"

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
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
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
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
