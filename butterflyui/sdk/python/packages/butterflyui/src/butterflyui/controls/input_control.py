from __future__ import annotations

from .capabilities.input import InputProps
from .focus_control import FocusControl
from .layout_control import LayoutControl

__all__ = ["InputControl"]


class InputControl(LayoutControl, FocusControl, InputProps):
    """
    Shared input behavior for controls that carry a user-editable value.
    """
