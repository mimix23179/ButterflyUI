from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["GradientEffect", "Gradient"]

@butterfly_control('gradient')
class GradientEffect(LayoutControl):
    """
    Apply a gradient fill or mesh gradient as a Styling helper surface.
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

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

Gradient = GradientEffect
