from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

__all__ = ["VirtualList"]

@butterfly_control('virtual_list', field_aliases={'controls': 'children'})
class VirtualList(ScrollableControl):
    """
    Virtualized scrollable list for large datasets with fixed item
    extent, separator support, and prefetch-near-end loading.

    When ``item_extent`` is set every row is given the same fixed height,
    enabling the scroll view to skip layout for off-screen items
    (significant performance gain for large lists).  ``cache_extent``
    controls how far off-screen the viewport pre-builds items.
    ``separator`` inserts ``Divider`` widgets between rows.  When
    ``has_more`` is ``True`` and the scroll position nears the end
    (within ``prefetch_threshold`` items), a ``"prefetch"`` event is
    emitted so the app can append more data.  Setting ``loading`` to
    ``True`` shows a loading indicator at the list’s tail.

    ```python
    import butterflyui as bui

    bui.VirtualList(
        items=[{"label": f"Row {i}"} for i in range(1000)],
        item_extent=48,
        separator=True,
        has_more=True,
        prefetch_threshold=20,
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

    item_extent: float | None = None
    """
    Fixed row height in logical pixels.  Enables constant-time scroll-offset calculations for large lists.
    """

    cache_extent: float | None = None
    """
    Cache extent in logical pixels — controls how far off-screen the viewport pre-builds items.
    """

    separator: bool | None = None
    """
    If ``True``, a ``Divider`` is inserted between each row.
    """

    has_more: bool | None = None
    """
    If ``True``, signals that more data can be requested when nearing the end.
    """

    loading: bool | None = None
    """
    If ``True``, a loading indicator is displayed at the tail of the list.
    """

    prefetch_threshold: int | None = None
    """
    Number of remaining items at which a ``"prefetch"`` event is emitted.
    """

    header: Any | None = None
    """
    Header value forwarded to the `virtual_list` runtime control.
    """

    footer: Any | None = None
    """
    Footer value forwarded to the `virtual_list` runtime control.
    """

    spacing: Any | None = None
    """
    Spacing between repeated child elements.
    """

    reverse: Any | None = None
    """
    Reverse value forwarded to the `virtual_list` runtime control.
    """

    skeleton_count: Any | None = None
    """
    Skeleton count value forwarded to the `virtual_list` runtime control.
    """

    use_positioned_list: Any | None = None
    """
    Use positioned list value forwarded to the `virtual_list` runtime control.
    """

    initial_index: Any | None = None
    """
    Initial index value forwarded to the `virtual_list` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `virtual_list` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `virtual_list` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `virtual_list` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `virtual_list` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `virtual_list` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `virtual_list` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `virtual_list` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `virtual_list` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `virtual_list` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `virtual_list` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `virtual_list` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `virtual_list` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `virtual_list` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `virtual_list` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `virtual_list` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `virtual_list` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `virtual_list` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `virtual_list` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `virtual_list` runtime control.
    """
