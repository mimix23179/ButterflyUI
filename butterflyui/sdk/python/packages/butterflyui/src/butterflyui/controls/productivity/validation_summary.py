from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ValidationSummary"]

class ValidationSummary(Component):
    """
    Summary block that lists form validation errors as a bulleted group.

    The runtime renders an error-summary banner above or below a form.
    ``title`` sets the heading. ``errors`` is a flat list of error strings
    to display.

    ```python
    import butterflyui as bui

    bui.ValidationSummary(
        title="Please fix the following:",
        errors=["Name is required.", "Email is invalid."],
    )
    ```

    Args:
        title:
            Heading displayed above the error list.
        errors:
            List of validation error message strings.
    """

    control_type = "validation_summary"

    def __init__(
        self,
        *,
        title: str | None = None,
        errors: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, errors=errors, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
