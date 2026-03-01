from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ScrollableRow"]

class ScrollableRow(Component):
    """
    Horizontally scrollable row of children.

    The runtime renders a horizontal ``ListView``-backed row. ``spacing`` adds
    a gap between children; ``reverse`` flips the scroll direction.
    ``content_padding`` adds padding around the scrollable area.
    ``initial_offset`` sets the starting scroll position.

    ```python
    import butterflyui as bui

    bui.ScrollableRow(
        *[bui.Text(f"Tab {i}") for i in range(10)],
        spacing=4,
        events=["scroll"],
    )
    ```

    Args:
        spacing:
            Horizontal gap between children in logical pixels.
        reverse:
            When ``True`` children are laid out in reverse scroll order.
        content_padding:
            Padding applied around the scrollable content area.
        initial_offset:
            Starting scroll offset in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "scrollable_row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
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
            spacing=spacing,
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

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})
