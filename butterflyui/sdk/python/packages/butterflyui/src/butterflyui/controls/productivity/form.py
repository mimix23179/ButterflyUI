from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["Form"]

class Form(Component):
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
