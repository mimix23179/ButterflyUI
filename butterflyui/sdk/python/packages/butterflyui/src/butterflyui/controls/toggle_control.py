from __future__ import annotations

from .form_field_control import FormFieldControl

__all__ = ["ToggleControl"]


class ToggleControl(FormFieldControl):
    """
    Shared boolean/toggle behavior for switch-like controls.
    """

    tristate: bool | None = None
    """
    Whether the control supports an indeterminate third state.
    """
