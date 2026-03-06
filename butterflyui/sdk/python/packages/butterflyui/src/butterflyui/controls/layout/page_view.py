from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["PageView"]


class PageView(Component):
    """Swipeable page container with index control and optional animation.
    
    ``PageView`` renders multiple children as horizontally or vertically
    swipeable pages. The active page is controlled by ``index`` and can be
    changed either declaratively (prop updates) or imperatively via invoke
    helpers such as :meth:`set_index`, :meth:`next_page`, and
    :meth:`previous_page`.
    
    Runtime supports both animated and instant page transitions. Layout knobs
    like ``viewport_fraction`` and ``pad_ends`` make it usable for carousel
    layouts in Gallery-like screens.
    
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
    
    Args:
        index:
            Zero-based index of the visible page.
        animate:
            If ``True``, page changes animate instead of switching instantly.
        duration_ms:
            Transition duration in milliseconds.
        keep_alive:
            If ``True``, keeps non-visible pages mounted.
        scroll_direction:
            Page axis: ``"horizontal"`` (default) or ``"vertical"``.
        reverse:
            If ``True``, reverses page traversal direction.
        page_snapping:
            If ``True``, releases snap to page boundaries.
        pad_ends:
            If ``True``, adds implicit padding at beginning/end when
            ``viewport_fraction`` is below ``1.0``.
        viewport_fraction:
            Fraction of viewport each page occupies. Useful for carousel-style
            previews. Typical range: ``0.6`` .. ``1.0``.
        initial_page:
            Alias for ``index``. When both are provided, ``index`` wins.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
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

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "page_view"

    def __init__(
        self,
        *children: Any,
        index: int | None = None,
        animate: bool | None = None,
        duration_ms: int | None = None,
        keep_alive: bool | None = None,
        scroll_direction: str | None = None,
        reverse: bool | None = None,
        page_snapping: bool | None = None,
        pad_ends: bool | None = None,
        viewport_fraction: float | None = None,
        initial_page: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            index=index,
            initial_page=initial_page if initial_page is not None else index,
            animate=animate,
            duration_ms=duration_ms,
            keep_alive=keep_alive,
            scroll_direction=scroll_direction,
            reverse=reverse,
            page_snapping=page_snapping,
            pad_ends=pad_ends,
            viewport_fraction=viewport_fraction,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

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
