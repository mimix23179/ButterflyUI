from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["FormField"]

@butterfly_control('form_field')
class FormField(FormFieldControl):
    """
    Labeled wrapper that adds decoration and validation state to a form input.

    The runtime wraps any input widget with a label row, optional helper
    text, and error text. ``label`` names the field. ``description`` adds
    a secondary hint. ``required`` appends a required indicator to the label.
    ``helper_text`` shows a hint below the input. ``error_text`` displays a
    validation error message.

    Example:

    ```python
    import butterflyui as bui

    bui.FormField(
        bui.TextInput(placeholder="Enter your name"),
        label="Full Name",
        required=True,
        helper_text="As shown on your ID",
    )
    ```
    """

    description: str | None = None
    """
    Secondary hint text displayed below the label.
    """
