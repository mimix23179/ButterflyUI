from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Pagination"]

@butterfly_control('pagination')
class Pagination(LayoutControl):
    """
    Unified pagination control for page-number and stepper-style navigation.

    ``Pagination`` is the canonical replacement for legacy ``page_nav`` and
    ``page_stepper`` controls. It supports numeric page buttons, previous/next
    actions, optional edge buttons, and computed page counts from total item
    counts.

    The Flutter runtime exposes imperative methods (``set_page``,
    ``next_page``, ``prev_page``, ``first_page``, ``last_page``) so server-side
    handlers can drive the active page after initial render.

    Example:

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
    """

    page: int | None = None
    """
    Current page index or page number used by the paginator.
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
    Label text rendered for the control's next-page or next-step action.
    """

    mode: str | None = None
    """
    Optional display mode hint (for example ``"numbers"`` or
    ``"stepper"``) interpreted by the renderer.
    """

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
