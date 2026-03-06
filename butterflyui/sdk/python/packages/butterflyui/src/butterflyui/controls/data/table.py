from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Table"]

@butterfly_control('table', field_aliases={'controls': 'children'})
class Table(LayoutControl):
    """
    Dual-axis scrollable table backed by Flutter’s ``DataTable`` with
    scroll-position invoke commands.

    The runtime renders a ``DataTable`` inside nested horizontal and
    vertical ``SingleChildScrollView`` widgets.  ``columns`` are used
    as plain header labels and ``rows`` as lists of cell values.
    Striped rows, dense mode, and header visibility are supported.
    Tapping a row emits ``"row_tap"`` with the ``index`` and ``row``
    values.  Scroll events (``"scroll_start"``, ``"scroll"``,
    ``"scroll_end"``) can be subscribed to via the ``events`` prop.
    Programmatic scrolling is available through ``scroll_to``,
    ``scroll_by``, ``scroll_to_start``, ``scroll_to_end``, and
    ``get_scroll_metrics`` invoke methods.

    ```python
    import butterflyui as bui

    bui.Table(
        columns=["Name", "Role", "Status"],
        rows=[
            ["Alice", "Engineer", "Active"],
            ["Bob", "Designer", "Away"],
        ],
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    columns: list[Any] | None = None
    """
    Column header labels — a list of plain strings.
    """

    rows: list[Any] | None = None
    """
    Row data — a list of lists where each inner list contains cell values aligned to ``columns``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `table` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `table` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `table` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `table` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `table` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `table` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `table` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `table` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `table` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `table` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `table` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `table` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `table` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `table` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `table` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `table` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `table` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `table` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `table` runtime control.
    """
