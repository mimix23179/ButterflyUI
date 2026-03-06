from __future__ import annotations

from typing import Any

__all__ = ["OverlayProps"]


class OverlayProps:
    """Shared popup and overlay presentation props."""

    open: bool | None = None
    """
    Whether the overlay is currently open or visible.
    """

    dismissible: bool | None = None
    """
    Whether the control can be dismissed by the user.
    """

    modal: bool | None = None
    """
    Whether the overlay should behave modally.
    """

    offset: Any = None
    """
    Offset applied by the runtime when positioning the overlay.
    """

    placement: str | None = None
    """
    Named overlay placement consumed by the runtime.
    """

    trap_focus: bool | None = None
    """
    Whether focus should remain trapped inside the overlay while open.
    """

    close_on_escape: bool | None = None
    """
    Whether pressing Escape should dismiss the overlay.
    """

    barrier_color: Any = None
    """
    Barrier or backdrop color rendered behind the overlay.
    """
