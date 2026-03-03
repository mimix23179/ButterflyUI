from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["TableView"]


class TableView(Component):
    """Presentation-first table surface with optional compact toolbar.

    ``TableView`` targets document/report screens and keeps table semantics while
    exposing table-specific chrome (caption, footer note, sticky header toggles).
    """

    control_type = "table_view"

    def __init__(
        self,
        *,
        columns: Sequence[Any] | None = None,
        rows: Sequence[Any] | None = None,
        caption: str | None = None,
        footer_note: str | None = None,
        sortable: bool | None = None,
        filterable: bool | None = None,
        selectable: bool | None = None,
        dense: bool | None = None,
        striped: bool | None = None,
        show_header: bool | None = None,
        sticky_header: bool | None = None,
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
                caption=caption,
                footer_note=footer_note,
                sortable=sortable,
                filterable=filterable,
                selectable=selectable,
                dense=dense,
                striped=striped,
                show_header=show_header,
                sticky_header=sticky_header,
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
