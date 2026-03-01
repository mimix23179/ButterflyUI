from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["VirtualList"]

class VirtualList(Component):
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

    Args:
        items: 
            Item payload list used to build rows when no explicit children are given.
        item_extent: 
            Fixed row height in logical pixels.  Enables constant-time scroll-offset calculations for large lists.
        cache_extent: 
            Cache extent in logical pixels — controls how far off-screen the viewport pre-builds items.
        separator: 
            If ``True``, a ``Divider`` is inserted between each row.
        has_more: 
            If ``True``, signals that more data can be requested when nearing the end.
        loading: 
            If ``True``, a loading indicator is displayed at the tail of the list.
        prefetch_threshold: 
            Number of remaining items at which a ``"prefetch"`` event is emitted.
    """

    control_type = "virtual_list"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        item_extent: float | None = None,
        cache_extent: float | None = None,
        separator: bool | None = None,
        has_more: bool | None = None,
        loading: bool | None = None,
        prefetch_threshold: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            item_extent=item_extent,
            cache_extent=cache_extent,
            separator=separator,
            has_more=has_more,
            loading=loading,
            prefetch_threshold=prefetch_threshold,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
