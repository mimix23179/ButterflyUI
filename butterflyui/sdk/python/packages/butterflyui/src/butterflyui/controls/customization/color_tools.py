from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ColorTools"]


class ColorTools(Component):
    """
    Composite color toolbox control that combines picker + swatch grid.

    Renders ``color_picker`` and ``color_swatch_grid`` together as one
    control so callers can manage value entry and palette selection from a
    single node.
    """

    control_type = "color_tools"

    def __init__(
        self,
        *,
        picker: Mapping[str, Any] | None = None,
        swatches: Mapping[str, Any] | None = None,
        presets: list[Any] | None = None,
        show_picker: bool | None = None,
        show_swatches: bool | None = None,
        spacing: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            picker=dict(picker) if picker is not None else None,
            swatches=dict(swatches) if swatches is not None else None,
            presets=presets,
            show_picker=show_picker,
            show_swatches=show_swatches,
            spacing=spacing,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

