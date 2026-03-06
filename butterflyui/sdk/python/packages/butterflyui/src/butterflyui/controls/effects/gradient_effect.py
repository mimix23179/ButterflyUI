from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["GradientEffect", "Gradient"]


class GradientEffect(Component):
    """
    Apply a gradient fill or mesh gradient to a child wrapper.
    """


    variant: str | None = None
    """
    Gradient variant name such as linear, radial, sweep, or mesh.
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

    opacity: float | None = None
    """
    Overall opacity applied to the gradient wrapper.
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

    control_type = "gradient"

    def __init__(
        self,
        *children: Any,
        variant: str | None = None,
        colors: list[Any] | None = None,
        stops: list[float] | None = None,
        tile_mode: str | None = None,
        begin: Any | None = None,
        end: Any | None = None,
        center: Any | None = None,
        radius: float | None = None,
        focal: Any | None = None,
        focal_radius: float | None = None,
        start_angle: float | None = None,
        end_angle: float | None = None,
        start_degrees: float | None = None,
        end_degrees: float | None = None,
        bgcolor: Any | None = None,
        background: Any | None = None,
        background_color: Any | None = None,
        opacity: float | None = None,
        mesh: list[Any] | None = None,
        mesh_points: list[Any] | None = None,
        points: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            colors=colors,
            stops=stops,
            tile_mode=tile_mode,
            begin=begin,
            end=end,
            center=center,
            radius=radius,
            focal=focal,
            focal_radius=focal_radius,
            start_angle=start_angle,
            end_angle=end_angle,
            start_degrees=start_degrees,
            end_degrees=end_degrees,
            bgcolor=bgcolor,
            background=background,
            background_color=background_color,
            opacity=opacity,
            mesh=mesh,
            mesh_points=mesh_points,
            points=points,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_colors(self, session: Any, colors: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_colors", {"colors": colors})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})


Gradient = GradientEffect
