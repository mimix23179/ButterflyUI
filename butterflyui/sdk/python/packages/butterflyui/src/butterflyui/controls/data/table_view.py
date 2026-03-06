from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any

from .._shared import Component, merge_props

__all__ = ["TableView"]


class TableView(Component):
    """Presentation-first table surface for report and document style layouts.
    
    ``TableView`` wraps table semantics with report-oriented chrome such as
    captions, footer notes, and sticky header behavior. Use this control when
    readability and narrative presentation matter more than dense spreadsheet
    ergonomics.
    
    Methods mirror :class:`DataGrid` so you can still drive sorting, filtering,
    and selection state imperatively from Python after initial render.
    
    ```python
    import butterflyui as bui
    
    table = bui.TableView(
        caption="Quarterly Revenue",
        footer_note="Values in USD",
        columns=[{"key": "region", "label": "Region"}, {"key": "amount", "label": "Amount"}],
        rows=[{"region": "EU", "amount": "$120,000"}],
        sticky_header=True,
        sortable=True,
    )
    ```
    
    Args:
        columns:
            Column descriptors consumed by the Flutter renderer.
        rows:
            Row objects rendered by the table.
        caption:
            Optional title/caption shown above table content.
        footer_note:
            Optional annotation shown near the table footer.
        sortable:
            Enables sort affordances in headers.
        filterable:
            Enables built-in query/filter behavior.
        selectable:
            Controls whether rows, items, or text content can be selected by the user.
        dense:
            Reduces row height and spacing for compact layouts.
        striped:
            Alternates row background treatment for readability.
        show_header:
            If ``False``, header row is hidden.
        sticky_header:
            Pins table header during vertical scrolling when supported.
        sort_column:
            Identifier of the column currently used to sort the control's data.
        sort_ascending:
            Controls whether the active sort uses ascending order instead of descending order.
        filter_query:
            Initial query string applied by the renderer.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    columns: Sequence[Any] | None = None
    """
    Column descriptors consumed by the Flutter renderer.
    """

    rows: Sequence[Any] | None = None
    """
    Row objects rendered by the table.
    """

    caption: str | None = None
    """
    Optional title/caption shown above table content.
    """

    footer_note: str | None = None
    """
    Optional annotation shown near the table footer.
    """

    sortable: bool | None = None
    """
    Enables sort affordances in headers.
    """

    filterable: bool | None = None
    """
    Enables built-in query/filter behavior.
    """

    selectable: bool | None = None
    """
    Controls whether rows, items, or text content can be selected by the user.
    """

    dense: bool | None = None
    """
    Reduces row height and spacing for compact layouts.
    """

    striped: bool | None = None
    """
    Alternates row background treatment for readability.
    """

    show_header: bool | None = None
    """
    If ``False``, header row is hidden.
    """

    sticky_header: bool | None = None
    """
    Pins table header during vertical scrolling when supported.
    """

    sort_column: str | None = None
    """
    Identifier of the column currently used to sort the control's data.
    """

    sort_ascending: bool | None = None
    """
    Controls whether the active sort uses ascending order instead of descending order.
    """

    filter_query: str | None = None
    """
    Initial query string applied by the renderer.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
        merged = merge_props(
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
                    )
        super().__init__(
            props=merged,
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
