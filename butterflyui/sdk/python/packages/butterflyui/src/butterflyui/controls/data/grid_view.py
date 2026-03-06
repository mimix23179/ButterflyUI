from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["GridView"]

@butterfly_control('grid_view', field_aliases={'controls': 'children'})
class GridView(ScrollableControl):
    """
    Multi-column grid layout that arranges child controls or item
    payloads into a configurable number of columns.

    When explicit ``children`` are supplied they are rendered directly as
    grid tiles.  Alternatively, an ``items`` payload list can be passed
    to let the runtime build tiles from data.  The ``columns`` parameter
    controls how many tiles appear per row.

    ```python
    import butterflyui as bui

    bui.GridView(
        bui.Text("A"), bui.Text("B"), bui.Text("C"), bui.Text("D"),
        columns=2,
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    columns: int | None = None
    """
    Number of grid columns.  Defaults to the runtime's layout heuristic when ``None``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `grid_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `grid_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `grid_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `grid_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `grid_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `grid_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `grid_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `grid_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `grid_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `grid_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `grid_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `grid_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `grid_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `grid_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `grid_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `grid_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `grid_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `grid_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `grid_view` runtime control.
    """
