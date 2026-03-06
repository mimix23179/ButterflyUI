from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["FieldGroup"]

@butterfly_control('field_group')
class FieldGroup(FormFieldControl):
    """
    Labeled vertical container for grouping related form fields.

    Renders a Flutter ``Column`` with an optional bold ``label``
    header, uniform ``spacing`` between child widgets, an optional
    ``helper_text`` shown below the group in a subdued style, and an
    optional ``error_text`` shown in red.  When ``required`` is
    ``True`` a red asterisk is appended to the label.

    Example:

    ```python
    import butterflyui as bui

    bui.FieldGroup(
        bui.TextField(label="First name"),
        bui.TextField(label="Last name"),
        label="Full name",
        required=True,
    )
    ```
    """

    spacing: float | None = None
    """
    Vertical gap in logical pixels between children.
    Defaults to ``8``.
    """
