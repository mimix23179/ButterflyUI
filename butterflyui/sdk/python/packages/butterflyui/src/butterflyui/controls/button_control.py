from __future__ import annotations

from .capabilities.actions import ActionProps, ButtonProps
from .focus_control import FocusControl
from .layout_control import LayoutControl

__all__ = ["ButtonControl"]


class ButtonControl(LayoutControl, FocusControl, ButtonProps, ActionProps):
    """
    Shared action-button behavior for clickable button controls.
    """
