from __future__ import annotations

from .capabilities.selection import ToggleProps
from .form_field_control import FormFieldControl

__all__ = ["ToggleControl"]


class ToggleControl(FormFieldControl, ToggleProps):
    """
    Shared boolean/toggle behavior for switch-like controls.
    """
