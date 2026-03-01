from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Paginator"]

class Paginator(Component):
    """
    Base pagination control that renders numbered page buttons.

    The runtime renders page number buttons computed from ``page_count`` or
    derived from ``total_items`` / ``page_size``. ``page`` sets the active
    page (1-based). ``max_visible`` caps how many page buttons are shown;
    ``show_edges`` adds first/last page jump buttons. Use ``PageNav`` for
    programmatic control methods.

    ```python
    import butterflyui as bui

    bui.Paginator(
        page=1,
        total_items=200,
        page_size=20,
        max_visible=7,
    )
    ```

    Args:
        page:
            Current page number (1-based).
        page_count:
            Total number of pages. Takes precedence over ``total_items`` /
            ``page_size``.
        page_size:
            Number of items per page used to calculate ``page_count``.
        total_items:
            Total item count used together with ``page_size`` to derive
            ``page_count``.
        max_visible:
            Maximum number of page number buttons to display at once.
        show_edges:
            When ``True`` first-page and last-page buttons are shown.
        dense:
            Reduces button height and padding.
    """

    control_type = "paginator"

    def __init__(
        self,
        *,
        page: int | None = None,
        page_count: int | None = None,
        page_size: int | None = None,
        total_items: int | None = None,
        max_visible: int | None = None,
        show_edges: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            page=page,
            page_count=page_count,
            page_size=page_size,
            total_items=total_items,
            max_visible=max_visible,
            show_edges=show_edges,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
