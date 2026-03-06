from __future__ import annotations

from .layout_control import LayoutControl

__all__ = ["ScrollableControl"]


class ScrollableControl(LayoutControl):
    """
    Shared scrollable behavior for controls with a viewport.
    """

    scrollable: bool | None = None
    """
    Whether the runtime should attach scrolling behavior.
    """

    initial_offset: float | None = None
    """
    Initial scroll position applied when the viewport is first built.
    """
