from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl


__all__ = ["DataGrid"]

@butterfly_control('data_grid', field_aliases={'controls': 'children'})
class DataGrid(ScrollableControl):
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
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
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
    Controls whether rows, items, or text content can be selected by the user.
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

    multi_select: Any | None = None
    """
    Multi select value forwarded to the `data_grid` runtime control.
    """

    pagination: Any | None = None
    """
    Pagination value forwarded to the `data_grid` runtime control.
    """

    auto_sort: Any | None = None
    """
    Auto sort value forwarded to the `data_grid` runtime control.
    """

    selected_index: Any | None = None
    """
    Currently selected item index.
    """

    filter_column: Any | None = None
    """
    Filter column value forwarded to the `data_grid` runtime control.
    """

    filter_case_sensitive: Any | None = None
    """
    Filter case sensitive value forwarded to the `data_grid` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `data_grid` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `data_grid` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `data_grid` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `data_grid` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `data_grid` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `data_grid` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `data_grid` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `data_grid` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `data_grid` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `data_grid` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `data_grid` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `data_grid` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `data_grid` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `data_grid` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `data_grid` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `data_grid` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `data_grid` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `data_grid` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `data_grid` runtime control.
    """

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
