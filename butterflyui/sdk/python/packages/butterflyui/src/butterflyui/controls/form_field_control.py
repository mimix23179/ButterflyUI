from __future__ import annotations

from .capabilities.input import FormFieldProps
from .input_control import InputControl

__all__ = ["FormFieldControl"]


class FormFieldControl(InputControl, FormFieldProps):
    """
    Shared input-field behavior for editable form controls.
    """
