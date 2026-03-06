from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["ScrollView"]

@butterfly_control('scroll_view', field_aliases={'controls': 'children'})
class ScrollView(ScrollableControl, MultiChildControl):
    """
    Scrollable container for arbitrary content along a configurable axis.

    The runtime wraps Flutter's ``SingleChildScrollView``. ``direction`` sets
    the scroll axis (``"vertical"`` or ``"horizontal"``); ``reverse`` flips
    the scroll direction. ``content_padding`` pads the inner content.
    ``initial_offset`` sets the starting scroll position.

    Example:

    ```python
    import butterflyui as bui

    bui.ScrollView(
        bui.Column(
            *[bui.Text(f"Row {i}") for i in range(50)],
        ),
        direction="vertical",
        events=["scroll"],
    )
    ```
    """

    direction: str | None = None
    """
    Scroll axis. Values: ``"vertical"`` (default), ``"horizontal"``.
    """

    reverse: bool | None = None
    """
    When ``True`` the content is scrolled in the reverse direction.
    """

    content_padding: Any | None = None
    """
    Padding applied inside the scrollable area.
    """

    axis: Any | None = None
    """
    Axis value forwarded to the `scroll_view` runtime control.
    """

    primary: Any | None = None
    """
    Primary value forwarded to the `scroll_view` runtime control.
    """

    physics: Any | None = None
    """
    Physics value forwarded to the `scroll_view` runtime control.
    """

    controller_id: Any | None = None
    """
    Controller id value forwarded to the `scroll_view` runtime control.
    """

    scrollbar: Any | None = None
    """
    Scrollbar value forwarded to the `scroll_view` runtime control.
    """

    thumb_visibility: Any | None = None
    """
    Thumb visibility value forwarded to the `scroll_view` runtime control.
    """

    track_visibility: Any | None = None
    """
    Track visibility value forwarded to the `scroll_view` runtime control.
    """

    def get_scroll_metrics(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_scroll_metrics", {})

    def scroll_to(
        self,
        session: Any,
        offset: float,
        *,
        animate: bool = True,
        duration_ms: int = 250,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_to",
            {
                "offset": offset,
                "animate": animate,
                "duration_ms": duration_ms,
            },
        )

    def scroll_by(
        self,
        session: Any,
        delta: float,
        *,
        animate: bool = True,
        duration_ms: int = 250,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "scroll_by",
            {
                "delta": delta,
                "animate": animate,
                "duration_ms": duration_ms,
            },
        )

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})
