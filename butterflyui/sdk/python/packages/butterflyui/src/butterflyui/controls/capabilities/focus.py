from __future__ import annotations

__all__ = ["FocusProps"]


class FocusProps:
    """Shared focus-related props."""

    autofocus: bool | None = None
    """
    Whether the control should request focus when it first appears.
    """

    focusable: bool | None = None
    """
    Whether the control should participate in keyboard focus traversal.
    """
