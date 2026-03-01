from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .tag_filter_bar import TagFilterBar

__all__ = ["FilterChipsBar"]

class FilterChipsBar(TagFilterBar):
    """
    Alias for :class:`TagFilterBar` emphasising a filter-chip use case.

    Provides identical behaviour and parameters to
    :class:`TagFilterBar`.  Use this name when the chips represent
    active filter criteria rather than generic tags.

    ```python
    import butterflyui as bui

    bui.FilterChipsBar(
        options=["Unread", "Starred", "Archived"],
        values=["Unread"],
        multi_select=True,
    )
    ```

    Args:
        options:
            List of filter items (strings or mappings with
            ``"label"``/``"value"`` keys).
        values:
            List of currently selected values.
        multi_select:
            If ``True`` (default), multiple chips can be active
            simultaneously.
        dense:
            If ``True``, chips use compact height and tighter padding.
    """
    control_type = "filter_chips_bar"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            options=options,
            values=values,
            multi_select=multi_select,
            dense=dense,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
