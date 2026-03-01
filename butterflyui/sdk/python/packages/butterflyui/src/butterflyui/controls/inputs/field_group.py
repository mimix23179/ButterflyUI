from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FieldGroup"]

class FieldGroup(Component):
    """
    Labeled vertical container for grouping related form fields.

    Renders a Flutter ``Column`` with an optional bold ``label``
    header, uniform ``spacing`` between child widgets, an optional
    ``helper_text`` shown below the group in a subdued style, and an
    optional ``error_text`` shown in red.  When ``required`` is
    ``True`` a red asterisk is appended to the label.

    ```python
    import butterflyui as bui

    bui.FieldGroup(
        bui.TextField(label="First name"),
        bui.TextField(label="Last name"),
        label="Full name",
        required=True,
    )
    ```

    Args:
        label:
            Bold header text rendered above the group.
        helper_text:
            Subdued helper note shown below the last child.
        error_text:
            Error message shown in red below the group.
        spacing:
            Vertical gap in logical pixels between children.
            Defaults to ``8``.
        required:
            If ``True``, a red ``" *"`` suffix is appended to
            ``label``.
    """
    control_type = "field_group"

    def __init__(
        self,
        *children: Any,
        label: str | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        spacing: float | None = None,
        required: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            helper_text=helper_text,
            error_text=error_text,
            spacing=spacing,
            required=required,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
