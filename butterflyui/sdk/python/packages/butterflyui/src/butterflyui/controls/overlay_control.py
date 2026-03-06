from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["OverlayControl"]


class OverlayControl(LayoutControl):
    """
    Shared overlay behavior for dismissible or positioned popup controls.
    """

    open: bool = False
    """
    Whether the overlay is currently visible.
    """

    dismissible: bool | None = None
    """
    Whether clicking outside or performing a dismiss action should close the
    overlay.
    """

    offset: Any = None
    """
    Placement offset applied by the runtime when positioning the overlay.
    """

    def show(self) -> "OverlayControl":
        self.open = True
        return self

    def hide(self) -> "OverlayControl":
        self.open = False
        return self
