from __future__ import annotations

from typing import Any

from .capabilities.scroll import ScrollProps
from .layout_control import LayoutControl

__all__ = ["ScrollableControl"]


class ScrollableControl(LayoutControl, ScrollProps):
    """
    Shared scrollable behavior for controls with a viewport.
    """

    def scroll_to(self, offset: float | None = None, *, animate: Any = None) -> "ScrollableControl":
        payload: dict[str, Any] = {}
        if offset is not None:
            payload["scroll_to"] = offset
        if animate is not None:
            payload["scroll_to_animate"] = animate
        if payload:
            self.patch(**payload)
        return self

    def scroll_by(self, delta: float, *, animate: Any = None) -> "ScrollableControl":
        payload: dict[str, Any] = {"scroll_by": delta}
        if animate is not None:
            payload["scroll_by_animate"] = animate
        self.patch(**payload)
        return self
