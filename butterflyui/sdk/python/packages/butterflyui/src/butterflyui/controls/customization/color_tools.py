from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ColorTools"]

@butterfly_control('color_tools')
class ColorTools(LayoutControl):
    """
    Composite color toolbox control that combines picker + swatch grid.

    Renders ``color_picker`` and ``color_swatch_grid`` together as one
    control so callers can manage value entry and palette selection from a
    single node.
    """

    picker: Mapping[str, Any] | None = None
    """
    Configuration forwarded to the embedded picker portion.
    """

    swatches: Mapping[str, Any] | None = None
    """
    Configuration forwarded to the embedded swatch grid portion.
    """

    presets: list[Any] | None = None
    """
    Preset colors exposed by the toolbox.
    """

    show_picker: bool | None = None
    """
    Whether the picker portion should be visible.
    """

    show_swatches: bool | None = None
    """
    Whether the swatch grid portion should be visible.
    """

    spacing: float | None = None
    """
    Spacing between the picker and swatch sections.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
