from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
__all__ = ["ScrollableColumn"]

@butterfly_control('scrollable_column', field_aliases={'controls': 'children'})
class ScrollableColumn(ScrollableControl, MultiChildControl):
    """
    Vertically scrollable column of children.

    The runtime renders a vertical ``ListView``-backed column. ``spacing``
    adds a gap between children; ``reverse`` flips the scroll direction so
    content starts from the bottom. ``content_padding`` adds padding around
    the scrollable area. ``initial_offset`` sets the starting scroll position.

    Example:

    ```python
    import butterflyui as bui

    bui.ScrollableColumn(
        *[bui.Text(f"Item {i}") for i in range(20)],
        spacing=8,
        events=["scroll"],
    )
    ```
    """

    spacing: float | None = None
    """
    Vertical gap between children in logical pixels.
    """

    reverse: bool | None = None
    """
    When ``True`` children are laid out in reverse scroll order.
    """

    content_padding: Any | None = None
    """
    Padding applied around the scrollable content area.
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

    def scroll_to_start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_start", {})

    def scroll_to_end(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "scroll_to_end", {})
