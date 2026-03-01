from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["FormField"]

class FormField(Component):
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
