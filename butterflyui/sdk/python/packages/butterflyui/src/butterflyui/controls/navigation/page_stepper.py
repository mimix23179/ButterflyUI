from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .page_nav import PageNav

__all__ = ["PageStepper"]

class PageStepper(PageNav):
    """
    Minimal prev/next page stepper control without individual page buttons.

    A lightweight specialization of ``PageNav`` that shows only previous
    and next step controls alongside a page indicator, rather than
    individual numbered page buttons.

    ```python
    import butterflyui as bui

    bui.PageStepper(
        page=1,
        page_count=5,
        events=["change"],
    )
    ```

    Args:
        page:
            Current page number (1-based).
        page_count:
            Total number of pages.
        page_size:
            Number of items per page used to calculate ``page_count``.
        total_items:
            Total item count used together with ``page_size``.
        max_visible:
            Maximum number of page number buttons to display.
        show_edges:
            When ``True`` first-page and last-page jump buttons are shown.
        dense:
            Reduces button height and padding.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "page_stepper"

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
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            page=page,
            page_count=page_count,
            page_size=page_size,
            total_items=total_items,
            max_visible=max_visible,
            show_edges=show_edges,
            dense=dense,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
