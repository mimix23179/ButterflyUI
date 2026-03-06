from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["GradientEffect", "Gradient"]

@butterfly_control('gradient')
class GradientEffect(LayoutControl):
    """
    Apply a gradient fill or mesh gradient to a child wrapper.
    """

    colors: list[Any] | None = None
    """
    Gradient color stops in display order.
    """

    stops: list[float] | None = None
    """
    Explicit stop positions aligned with ``colors``.
    """

    tile_mode: str | None = None
    """
    Tile mode forwarded to the runtime gradient builder.
    """

    begin: Any | None = None
    """
    Begin alignment or position for linear gradients.
    """

    end: Any | None = None
    """
    End alignment or position for linear gradients.
    """

    center: Any | None = None
    """
    Center position for radial or sweep gradients.
    """

    radius: float | None = None
    """
    Radius used by radial gradients.
    """

    focal: Any | None = None
    """
    Focal point used by focal radial gradients.
    """

    focal_radius: float | None = None
    """
    Radius of the focal point highlight.
    """

    start_angle: float | None = None
    """
    Sweep gradient start angle in radians.
    """

    end_angle: float | None = None
    """
    Sweep gradient end angle in radians.
    """

    start_degrees: float | None = None
    """
    Sweep gradient start angle in degrees.
    """

    end_degrees: float | None = None
    """
    Sweep gradient end angle in degrees.
    """

    bgcolor: Any | None = None
    """
    Flat background color blended with the gradient.
    """

    background: Any | None = None
    """
    Alias background payload for the wrapper.
    """

    background_color: Any | None = None
    """
    Alternate background color alias.
    """

    mesh: list[Any] | None = None
    """
    Mesh gradient definition payload.
    """

    mesh_points: list[Any] | None = None
    """
    Mesh control points used by the runtime.
    """

    points: list[Any] | None = None
    """
    Alternate mesh point payload alias.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `gradient` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `gradient` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `gradient` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `gradient` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `gradient` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `gradient` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `gradient` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `gradient` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `gradient` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `gradient` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `gradient` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `gradient` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `gradient` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `gradient` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `gradient` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `gradient` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `gradient` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `gradient` runtime control.
    """

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

Gradient = GradientEffect
