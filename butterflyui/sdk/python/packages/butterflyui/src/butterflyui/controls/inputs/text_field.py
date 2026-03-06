from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["TextField"]

@butterfly_control('text_field', positional_fields=('value',))
class TextField(FormFieldControl):
    """
    Single-line text input field.

    Renders a Flutter ``TextField`` with a single line of editable
    text.  The optional ``label`` floats above the field when focused;
    ``placeholder`` is shown as hint text when the field is empty.
    Submitting the field (pressing *Enter*) emits a ``submit`` event;
    changes can also be observed via the ``change`` event.

    Example:

    ```python
    import butterflyui as bui

    bui.TextField(placeholder="Enter your name", label="Name")
    ```
    """
