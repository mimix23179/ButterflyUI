from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ValidationSummary"]

class ValidationSummary(Component):
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
