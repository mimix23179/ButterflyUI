from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["SortableHeader"]

@butterfly_control('sortable_header')
class SortableHeader(LayoutControl):
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
    """

    columns: list[Mapping[str, Any]] | None = None
    """
    Header column definitions — list of mappings with ``"key"`` (or ``"id"``/``"field"``) and ``"label"`` (or ``"title"``) keys.
    """

    sort_column: str | None = None
    """
    The ``key`` of the currently sorted column.  ``None`` means no column is sorted.
    """

    sort_ascending: bool | None = None
    """
    Controls whether (default), the current sort direction is ascending. Set it to ``False`` to disable this behavior.
    """

    dense: bool | None = None
    """
    If ``True``, header chips use compact padding and smaller icon size.
    """

    options: Any | None = None
    """
    Option descriptors rendered by the control.
    """

    selected: Any | None = None
    """
    Selected value forwarded to the `sortable_header` runtime control.
    """

    selected_index: Any | None = None
    """
    Currently selected item index.
    """

    label: Any | None = None
    """
    Primary label rendered by the control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `sortable_header` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `sortable_header` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `sortable_header` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `sortable_header` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `sortable_header` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `sortable_header` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `sortable_header` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `sortable_header` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `sortable_header` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `sortable_header` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `sortable_header` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `sortable_header` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `sortable_header` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `sortable_header` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `sortable_header` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `sortable_header` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `sortable_header` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `sortable_header` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `sortable_header` runtime control.
    """

    def set_sort(self, session: Any, *, column: str, ascending: bool = True) -> dict[str, Any]:
        return self.invoke(session, "set_sort", {"column": column, "ascending": ascending})

    def clear_sort(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear_sort", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
