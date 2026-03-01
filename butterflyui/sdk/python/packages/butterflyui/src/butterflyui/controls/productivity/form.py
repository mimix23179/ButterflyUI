from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["Form"]

class Form(Component):
    """
    Layout container that groups form fields with an optional title and spacing.

    The runtime renders a vertical form scaffold. ``title`` and
    ``description`` add a header above the fields. ``spacing`` sets the
    gap between child field widgets. Fields are passed as children.

    ```python
    import butterflyui as bui

    bui.Form(
        bui.FormField(bui.TextInput(), label="Name"),
        title="User Details",
        spacing=16,
    )
    ```

    Args:
        title:
            Optional heading displayed at the top of the form.
        description:
            Optional description text displayed below the title.
        spacing:
            Vertical gap in logical pixels between form field children.
    """

    control_type = "form"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        description: str | None = None,
        spacing: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            description=description,
            spacing=spacing,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
