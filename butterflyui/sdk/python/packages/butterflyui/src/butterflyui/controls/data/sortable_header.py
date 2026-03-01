from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SortableHeader"]

class SortableHeader(Component):
    """
    Clickable column-header row that tracks the currently sorted column
    and direction.

    The runtime renders a ``Wrap`` of tappable header chips.  Each
    column mapping should carry a ``key`` (or ``id``/``field``) and a
    ``label`` (or ``title``).  The chip for the active ``sort_column``
    shows an ascending or descending arrow; all others show an
    ``unfold_more`` icon.  Tapping a chip emits a ``"sort_change"``
    event with ``column``, ``sort_column``, and ``sort_ascending``
    keys.  Use ``set_sort()`` to change the sort state
    programmatically or ``clear_sort()`` to reset it.

    ```python
    import butterflyui as bui

    bui.SortableHeader(
        columns=[
            {"key": "name", "label": "Name"},
            {"key": "date", "label": "Date"},
            {"key": "size", "label": "Size"},
        ],
        sort_column="name",
        sort_ascending=True,
        dense=True,
    )
    ```

    Args:
        columns: 
            Header column definitions — list of mappings with ``"key"`` (or ``"id"``/``"field"``) and ``"label"`` (or ``"title"``) keys.
        sort_column: 
            The ``key`` of the currently sorted column.  ``None`` means no column is sorted.
        sort_ascending: 
            If ``True`` (default), the current sort direction is ascending.
        dense: 
            If ``True``, header chips use compact padding and smaller icon size.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "sortable_header"

    def __init__(
        self,
        *,
        columns: list[Mapping[str, Any]] | None = None,
        sort_column: str | None = None,
        sort_ascending: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            columns=[dict(column) for column in (columns or [])],
            sort_column=sort_column,
            sort_ascending=sort_ascending,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_sort(self, session: Any, *, column: str, ascending: bool = True) -> dict[str, Any]:
        return self.invoke(session, "set_sort", {"column": column, "ascending": ascending})

    def clear_sort(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_sort", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
