from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Grid"]

@butterfly_control('grid', field_aliases={'controls': 'children'})
class Grid(LayoutControl):
    """
    Grid layout that arranges children into a fixed number of columns.

    The runtime renders a Flutter ``GridView.count``. ``columns`` sets the
    cross-axis count; ``spacing`` and ``run_spacing`` add gaps between cells.
    ``child_aspect_ratio`` fixes each cell's width-to-height ratio.
    ``direction`` switches between vertical and horizontal scrolling.
    ``shrink_wrap`` sizes the grid to its content instead of filling the parent.

    Example:

    ```python
    import butterflyui as bui

    bui.Grid(
        items=[{"label": "A"}, {"label": "B"}, {"label": "C"}],
        columns=3,
        spacing=8,
        child_aspect_ratio=1.0,
        events=["select"],
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
    Number of columns (cross-axis cell count).
    """

    spacing: float | None = None
    """
    Horizontal gap between cells in logical pixels.
    """

    run_spacing: float | None = None
    """
    Vertical gap between rows in logical pixels.
    """

    child_aspect_ratio: float | None = None
    """
    Width-to-height ratio for each cell. Defaults to ``1.0``.
    """

    direction: str | None = None
    """
    Scroll axis. Values: ``"vertical"`` (default), ``"horizontal"``.
    """

    reverse: bool | None = None
    """
    When ``True`` items are laid out in reverse order.
    """

    shrink_wrap: bool | None = None
    """
    When ``True`` the grid sizes itself to its content.
    """

    layout: Any | None = None
    """
    Layout value forwarded to the `grid` runtime control.
    """

    masonry: Any | None = None
    """
    Masonry value forwarded to the `grid` runtime control.
    """

    scrollable: Any | None = None
    """
    Whether the control should render inside a scrollable viewport.
    """

    virtual: Any | None = None
    """
    Virtual value forwarded to the `grid` runtime control.
    """

    virtualized: Any | None = None
    """
    Virtualized value forwarded to the `grid` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `grid` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `grid` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `grid` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `grid` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `grid` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `grid` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `grid` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `grid` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `grid` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `grid` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `grid` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `grid` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `grid` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `grid` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `grid` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `grid` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `grid` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `grid` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `grid` runtime control.
    """
