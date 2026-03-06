from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["VirtualList"]

@butterfly_control('virtual_list', field_aliases={'controls': 'children'})
class VirtualList(ScrollableControl, MultiChildControl):
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
