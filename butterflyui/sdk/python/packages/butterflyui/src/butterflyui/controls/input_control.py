from __future__ import annotations

from typing import Any

from .layout_control import LayoutControl

__all__ = ["InputControl"]


class InputControl(LayoutControl):
    """
    Shared input behavior for controls that carry a user-editable value.
    """

    value: Any = None
    """
    Current value held by the input control.
    """

    label: str | None = None
    """
    Human-readable label shown with the input.
    """

    placeholder: str | None = None
    """
    Hint text shown when the input value is empty.
    """

    helper_text: str | None = None
    """
    Supporting helper text rendered with the field.
    """

    error_text: str | None = None
    """
    Error message rendered when the field is invalid.
    """

    read_only: bool | None = None
    """
    Whether the current value can be viewed but not edited.
    """

    autofocus: bool | None = None
    """
    Whether the control should request focus when first built.
    """

    dense: bool | None = None
    """
    Whether the control should use a more compact visual density.
    """
