from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["EditorTabStrip"]

class EditorTabStrip(Component):
    control_type = "editor_tab_strip"

    def __init__(
        self,
        *,
        tabs: list[dict[str, Any]] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, tabs=tabs, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
