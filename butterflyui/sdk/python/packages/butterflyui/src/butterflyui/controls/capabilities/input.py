from __future__ import annotations

from typing import Any

__all__ = ["InputProps", "FormFieldProps"]


class InputProps:
    """Shared value and editable-input props."""

    value: Any = None
    """
    Current value held by the control.
    """

    label: str | None = None
    """
    Primary label rendered by the control.
    """

    placeholder: str | None = None
    """
    Hint text shown when the control has no value.
    """

    helper_text: str | None = None
    """
    Supporting helper text rendered with the control.
    """

    error_text: str | None = None
    """
    Validation error message shown with the control.
    """

    read_only: bool | None = None
    """
    Whether the current value can be viewed but not edited.
    """

    dense: bool | None = None
    """
    Whether the runtime should use a more compact visual density.
    """


class FormFieldProps:
    """Shared form-field metadata props."""

    name: str | None = None
    """
    Form field name used when submitting or validating this control.
    """

    required: bool | None = None
    """
    Whether the control must have a value.
    """

    debounce_ms: int | None = None
    """
    Debounce duration applied before emitting change events.
    """

    helper: Any = None
    """
    Supporting helper content rendered with the control.
    """

    error: Any = None
    """
    Validation error message or descriptor associated with the control.
    """
