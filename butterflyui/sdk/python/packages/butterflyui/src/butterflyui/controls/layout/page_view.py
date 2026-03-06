from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl


__all__ = ["PageView"]

@butterfly_control('page_view', field_aliases={'controls': 'children'})
class PageView(ScrollableControl):
    """
    Swipeable page container with index control and optional animation.

    ``PageView`` renders multiple children as horizontally or vertically
    swipeable pages. The active page is controlled by ``index`` and can be
    changed either declaratively (prop updates) or imperatively via invoke
    helpers such as :meth:`set_index`, :meth:`next_page`, and
    :meth:`previous_page`.

    Runtime supports both animated and instant page transitions. Layout knobs
    like ``viewport_fraction`` and ``pad_ends`` make it usable for carousel
    layouts in Gallery-like screens.

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

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `page_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `page_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `page_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `page_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `page_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `page_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `page_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `page_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `page_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `page_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `page_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `page_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `page_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `page_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `page_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `page_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `page_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `page_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `page_view` runtime control.
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
