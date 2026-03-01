from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ScrollView"]

class ScrollView(Component):
    """
    Scrollable container for arbitrary content along a configurable axis.

    The runtime wraps Flutter's ``SingleChildScrollView``. ``direction`` sets
    the scroll axis (``"vertical"`` or ``"horizontal"``); ``reverse`` flips
    the scroll direction. ``content_padding`` pads the inner content.
    ``initial_offset`` sets the starting scroll position.

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

    Args:
        direction:
            Scroll axis. Values: ``"vertical"`` (default), ``"horizontal"``.
        reverse:
            When ``True`` the content is scrolled in the reverse direction.
        content_padding:
            Padding applied inside the scrollable area.
        initial_offset:
            Starting scroll offset in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "scroll_view"

    def __init__(
        self,
        *children: Any,
        direction: str | None = None,
        reverse: bool | None = None,
        content_padding: Any | None = None,
        initial_offset: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            direction=direction,
            reverse=reverse,
            content_padding=content_padding,
            initial_offset=initial_offset,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

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
