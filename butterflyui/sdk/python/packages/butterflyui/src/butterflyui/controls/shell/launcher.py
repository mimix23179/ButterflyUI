from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Launcher"]

class Launcher(Component):
    control_type = "launcher"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        layout: str | None = None,
        columns: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            selected_id=selected_id,
            layout=layout,
            columns=columns,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
