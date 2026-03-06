from __future__ import annotations

from .capabilities.overlay import OverlayProps
from .layout_control import LayoutControl

__all__ = ["OverlayControl"]


class OverlayControl(LayoutControl, OverlayProps):
    """
    Shared overlay behavior for dismissible or positioned popup controls.
    """

    def show(self) -> "OverlayControl":
        self.open = True
        return self

    def hide(self) -> "OverlayControl":
        self.open = False
        return self
