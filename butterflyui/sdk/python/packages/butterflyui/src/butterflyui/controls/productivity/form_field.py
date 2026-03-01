from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["FormField"]

class FormField(Component):
    """
    Labeled wrapper that adds decoration and validation state to a form input.

    The runtime wraps any input widget with a label row, optional helper
    text, and error text. ``label`` names the field. ``description`` adds
    a secondary hint. ``required`` appends a required indicator to the label.
    ``helper_text`` shows a hint below the input. ``error_text`` displays a
    validation error message.

    ```python
    import butterflyui as bui

    bui.FormField(
        bui.TextInput(placeholder="Enter your name"),
        label="Full Name",
        required=True,
        helper_text="As shown on your ID",
    )
    ```

    Args:
        label:
            Field label text shown above or beside the input.
        description:
            Secondary hint text displayed below the label.
        required:
            When ``True`` a required indicator is added to the label.
        helper_text:
            Hint text shown below the input when no error is present.
        error_text:
            Validation error message shown below the input.
    """

    control_type = "form_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        label: str | None = None,
        description: str | None = None,
        required: bool | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            description=description,
            required=required,
            helper_text=helper_text,
            error_text=error_text,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
