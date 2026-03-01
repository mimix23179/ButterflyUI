from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TextField"]

class TextField(Component):
    """
    Single-line text input field.

    Renders a Flutter ``TextField`` with a single line of editable
    text.  The optional ``label`` floats above the field when focused;
    ``placeholder`` is shown as hint text when the field is empty.
    Submitting the field (pressing *Enter*) emits a ``submit`` event;
    changes can also be observed via the ``change`` event.

    ```python
    import butterflyui as bui

    bui.TextField(placeholder="Enter your name", label="Name")
    ```

    Args:
        value:
            Initial text value.
        placeholder:
            Hint text displayed when the field is empty.
        label:
            Floating label text shown above the field when focused.
    """
    control_type = "text_field"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        label: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            label=label,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
