from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .paginator import Paginator

__all__ = ["PageNav"]

class PageNav(Paginator):
    """
    Keyboard-and-click page navigation bar with edge buttons.

    Extends ``Paginator`` with programmatic control methods (``set_page``,
    ``next_page``, ``prev_page``) and event emission. ``show_edges`` adds
    first/last page jump buttons. ``max_visible`` limits the number of page
    number buttons shown at once.

    ```python
    import butterflyui as bui

    bui.PageNav(
        page=1,
        page_count=10,
        max_visible=5,
        show_edges=True,
        events=["change"],
    )
    ```

    Args:
        page:
            Current page number (1-based).
        page_count:
            Total number of pages. Derived from ``total_items`` and
            ``page_size`` if not provided.
        page_size:
            Number of items per page used to calculate ``page_count``.
        total_items:
            Total item count used together with ``page_size`` to derive
            ``page_count``.
        max_visible:
            Maximum number of page number buttons to display.
        show_edges:
            When ``True`` first-page and last-page jump buttons are shown.
        dense:
            Reduces button height and padding.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "page_nav"

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
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_page(self, session: Any, page: int) -> dict[str, Any]:
        return self.invoke(session, "set_page", {"page": page})

    def next_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "next_page", {})

    def prev_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "prev_page", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
