from __future__ import annotations

from typing import Any

from .input_control import InputControl

__all__ = ["FormFieldControl"]


class FormFieldControl(InputControl):
    """
    Shared input-field behavior for editable form controls.
    """

    name: str | None = None
    """
    Application-defined field name used by forms or validation layers.
    """

    required: bool | None = None
    """
    Whether the field is required before form submission succeeds.
    """

    debounce_ms: int | None = None
    """
    Debounce duration applied before change events are emitted.
    """

    helper: Any = None
    """
    Helper content rendered alongside or below the field.
    """

    error: Any = None
    """
    Error content rendered when the field is invalid.
    """
