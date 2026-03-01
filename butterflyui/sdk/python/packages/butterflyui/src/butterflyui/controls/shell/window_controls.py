from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["WindowControls"]

class WindowControls(Component):
    control_type = "window_controls"

    def __init__(
        self,
        *,
        show_minimize: bool | None = None,
        show_maximize: bool | None = None,
        show_close: bool | None = None,
        spacing: float | None = None,
        button_width: float | None = None,
        button_height: float | None = None,
        radius: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            show_minimize=show_minimize,
            show_maximize=show_maximize,
            show_close=show_close,
            spacing=spacing,
            button_width=button_width,
            button_height=button_height,
            radius=radius,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
