from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl


__all__ = ["TableView"]

@butterfly_control('table_view', field_aliases={'controls': 'children'})
class TableView(ScrollableControl):
    """
    Presentation-first table surface for report and document style layouts.

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

    headers: Any | None = None
    """
    Headers value forwarded to the `table_view` runtime control.
    """

    multi_select: Any | None = None
    """
    Multi select value forwarded to the `table_view` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `table_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `table_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `table_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `table_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `table_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `table_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `table_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `table_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `table_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `table_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `table_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `table_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `table_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `table_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `table_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `table_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `table_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `table_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `table_view` runtime control.
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
