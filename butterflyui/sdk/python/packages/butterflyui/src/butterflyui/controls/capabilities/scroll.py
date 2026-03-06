from __future__ import annotations

from typing import Any

__all__ = ["ScrollProps"]


class ScrollProps:
    """Shared scrollable-viewport props."""

    scroll: Any = None
    """
    Scroll mode or descriptor used by the runtime.
    """

    scroll_direction: str | None = None
    """
    Scroll direction hint used by the runtime.
    """

    scrollable: bool | None = None
    """
    Whether the control should render inside a scrollable viewport.
    """

    auto_scroll: bool | None = None
    """
    Whether the viewport should automatically scroll to the end on updates.
    """

    reverse: bool | None = None
    """
    Whether the scroll direction should be reversed.
    """

    initial_offset: float | None = None
    """
    Initial scroll offset applied by the runtime.
    """

    scroll_interval: int | None = None
    """
    Scroll event throttling interval in milliseconds.
    """
