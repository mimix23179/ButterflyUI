from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["VirtualGrid"]

@butterfly_control('virtual_grid', field_aliases={'controls': 'children'})
class VirtualGrid(ScrollableControl):
    """
    Virtualized grid view for large datasets with prefetch-near-end
    and loading-state support.

    Items are arranged into ``columns`` columns.  ``spacing`` and
    ``run_spacing`` control the gap between tiles along the main and
    cross axes respectively, while ``child_aspect_ratio`` sets the
    width/height ratio per tile.  When ``has_more`` is ``True`` and
    the user scrolls within ``prefetch_threshold`` items of the end,
    a ``"prefetch"`` event is emitted so the app can append more data.
    Setting ``loading`` to ``True`` displays a loading indicator at the
    grid’s tail.

    ```python
    import butterflyui as bui

    bui.VirtualGrid(
        items=[{"label": f"Tile {i}"} for i in range(100)],
        columns=3,
        spacing=8,
        child_aspect_ratio=1.0,
        has_more=True,
        prefetch_threshold=10,
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
    Number of columns used when the control lays out content in a grid.
    """

    spacing: float | None = None
    """
    Main-axis spacing in logical pixels between tiles.
    """

    run_spacing: float | None = None
    """
    Cross-axis spacing in logical pixels between tile runs.
    """

    child_aspect_ratio: float | None = None
    """
    Width-to-height ratio of each tile (e.g. ``1.0`` for square tiles).
    """

    has_more: bool | None = None
    """
    If ``True``, signals that more data can be requested when nearing the end.
    """

    loading: bool | None = None
    """
    If ``True``, a loading indicator is displayed at the tail of the grid.
    """

    prefetch_threshold: int | None = None
    """
    Number of remaining items at which a ``"prefetch"`` event is emitted.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `virtual_grid` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `virtual_grid` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `virtual_grid` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `virtual_grid` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `virtual_grid` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `virtual_grid` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `virtual_grid` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `virtual_grid` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `virtual_grid` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `virtual_grid` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `virtual_grid` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `virtual_grid` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `virtual_grid` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `virtual_grid` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `virtual_grid` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `virtual_grid` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `virtual_grid` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `virtual_grid` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `virtual_grid` runtime control.
    """
