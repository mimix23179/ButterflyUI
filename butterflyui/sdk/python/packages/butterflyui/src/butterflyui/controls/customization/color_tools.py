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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `color_tools` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `color_tools` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `color_tools` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `color_tools` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `color_tools` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `color_tools` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `color_tools` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `color_tools` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `color_tools` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `color_tools` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `color_tools` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `color_tools` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `color_tools` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `color_tools` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `color_tools` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `color_tools` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `color_tools` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `color_tools` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `color_tools` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
