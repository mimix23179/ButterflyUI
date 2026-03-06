from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Pagination"]


class Pagination(Component):
    """
    Unified pagination control for page-number and stepper-style navigation.

    ``Pagination`` is the canonical replacement for legacy ``page_nav`` and
    ``page_stepper`` controls. It supports numeric page buttons, previous/next
    actions, optional edge buttons, and computed page counts from total item
    counts.

    The Flutter runtime exposes imperative methods (``set_page``,
    ``next_page``, ``prev_page``, ``first_page``, ``last_page``) so server-side
    handlers can drive the active page after initial render.

    ```python
    import butterflyui as bui

    pager = bui.Pagination(
        page=1,
        total_items=420,
        page_size=20,
        max_visible=7,
        show_edges=True,
        dense=False,
        events=["change"],
    )
    ```

    Args:
        page:
            Current page number (1-based).
        page_count:
            Total number of pages. If omitted, the renderer can derive it from
            ``total_items`` and ``page_size``.
        page_size:
            Number of items per page used for derived ``page_count``.
        total_items:
            Total item count used with ``page_size`` to derive ``page_count``.
        max_visible:
            Maximum number of visible page buttons in numeric mode.
        show_edges:
            If ``True``, first/last jump buttons are shown when truncated.
        dense:
            Uses compact spacing and control sizing.
        prev_label:
            Label for the previous-page action.
        next_label:
            Label for the next-page action.
        mode:
            Optional display mode hint (for example ``"numbers"`` or
            ``"stepper"``) interpreted by the renderer.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    page: int | None = None
    """
    Current page number (1-based).
    """

    page_count: int | None = None
    """
    Total number of pages. If omitted, the renderer can derive it from
    ``total_items`` and ``page_size``.
    """

    page_size: int | None = None
    """
    Number of items per page used for derived ``page_count``.
    """

    total_items: int | None = None
    """
    Total item count used with ``page_size`` to derive ``page_count``.
    """

    max_visible: int | None = None
    """
    Maximum number of visible page buttons in numeric mode.
    """

    show_edges: bool | None = None
    """
    If ``True``, first/last jump buttons are shown when truncated.
    """

    dense: bool | None = None
    """
    Uses compact spacing and control sizing.
    """

    prev_label: str | None = None
    """
    Label for the previous-page action.
    """

    next_label: str | None = None
    """
    Label for the next-page action.
    """

    mode: str | None = None
    """
    Optional display mode hint (for example ``"numbers"`` or
    ``"stepper"``) interpreted by the renderer.
    """

    events: list[str] | None = None
    """
    Event names the Flutter side should emit to Python.
    """

    control_type = "pagination"

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
        prev_label: str | None = None,
        next_label: str | None = None,
        mode: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                page=page,
                page_count=page_count,
                page_size=page_size,
                total_items=total_items,
                max_visible=max_visible,
                show_edges=show_edges,
                dense=dense,
                prev_label=prev_label,
                next_label=next_label,
                mode=mode,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_page(self, session: Any, page: int) -> dict[str, Any]:
        return self.invoke(session, "set_page", {"page": int(page)})

    def next_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "next_page", {})

    def prev_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "prev_page", {})

    def first_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "first_page", {})

    def last_page(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "last_page", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )

