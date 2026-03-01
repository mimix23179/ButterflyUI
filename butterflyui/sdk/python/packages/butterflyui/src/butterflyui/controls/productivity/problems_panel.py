from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ProblemsPanel"]

class ProblemsPanel(Component):
    control_type = "problems_panel"

    def __init__(
        self,
        *,
        problems: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, problems=problems, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
