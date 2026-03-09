from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["PageView"]

@butterfly_control('page_view', field_aliases={'controls': 'children'})
class PageView(ScrollableControl, MultiChildControl):
    """
    Swipeable page container with index control and optional animation.

    ``PageView`` renders multiple children as horizontally or vertically
    swipeable pages. The active page is controlled by ``index`` and can be
    changed either declaratively (prop updates) or imperatively via invoke
    helpers such as :meth:`set_index`, :meth:`next_page`, and
    :meth:`previous_page`.

    Runtime supports both animated and instant page transitions. Layout knobs
    like ``viewport_fraction`` and ``pad_ends`` make it usable for carousel
    and preview-heavy layouts.

    Example:

    ```python
    import butterflyui as bui

    bui.PageView(
        bui.Text("Overview"),
        bui.Text("Details"),
        index=0,
        animate=True,
        duration_ms=240,
        viewport_fraction=0.92,
        events=["change"],
    )
    ```
    """

    index: int | None = None
    """
    Zero-based index of the visible page.
    """

    animate: bool | None = None
    """
    If ``True``, page changes animate instead of switching instantly.
    """

    duration_ms: int | None = None
    """
    Transition duration in milliseconds.
    """

    keep_alive: bool | None = None
    """
    If ``True``, keeps non-visible pages mounted.
    """

    scroll_direction: str | None = None
    """
    Page axis: ``"horizontal"`` (default) or ``"vertical"``.
    """

    reverse: bool | None = None
    """
    If ``True``, reverses page traversal direction.
    """

    page_snapping: bool | None = None
    """
    If ``True``, releases snap to page boundaries.
    """

    pad_ends: bool | None = None
    """
    If ``True``, adds implicit padding at beginning/end when
    ``viewport_fraction`` is below ``1.0``.
    """

    viewport_fraction: float | None = None
    """
    Fraction of viewport each page occupies. Useful for carousel-style
    previews. Typical range: ``0.6`` .. ``1.0``.
    """

    initial_page: int | None = None
    """
    Alias for ``index``. When both are provided, ``index`` wins.
    """

    def set_index(self, session: Any, index: int, *, animated: bool | None = None, duration_ms: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {"index": int(index)}
        if animated is not None:
            payload["animated"] = bool(animated)
        if duration_ms is not None:
            payload["duration_ms"] = int(duration_ms)
        return self.invoke(session, "set_index", payload)

    def next_page(self, session: Any, *, animated: bool | None = None, duration_ms: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if animated is not None:
            payload["animated"] = bool(animated)
        if duration_ms is not None:
            payload["duration_ms"] = int(duration_ms)
        return self.invoke(session, "next_page", payload)

    def previous_page(self, session: Any, *, animated: bool | None = None, duration_ms: int | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if animated is not None:
            payload["animated"] = bool(animated)
        if duration_ms is not None:
            payload["duration_ms"] = int(duration_ms)
        return self.invoke(session, "previous_page", payload)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
