from __future__ import annotations

from .capabilities.selection import SelectionProps
from .form_field_control import FormFieldControl

__all__ = ["SelectionControl"]


class SelectionControl(FormFieldControl, SelectionProps):
    """
    Shared selection-list behavior for choice-based controls.
    """
