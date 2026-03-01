from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Gradient"]

class Gradient(Component):
    """
    Applies a static gradient fill (linear, radial, or sweep) to a child.

    The runtime wraps the child in a ``Container`` with a ``BoxDecoration``
    whose gradient is built from the supplied colours. An ``Opacity`` widget
    is applied when `opacity` < 1.

    ```python
    import butterflyui as bui

    bui.Gradient(
        my_content,
        variant="linear",
        colors=["#7c3aed", "#06b6d4"],
        begin="top_left",
        end="bottom_right",
    )
    ```

    Args:
        variant: 
            Gradient type: ``"linear"`` (default), ``"radial"``, or ``"sweep"`` / ``"conic"``.
        colors: 
            List of colour values (hex strings). At least two are required.
        stops: 
            Stop positions in ``[0.0, 1.0]`` matching the length of `colors`.
        tile_mode: 
            How the gradient tiles beyond its bounds: ``"clamp"``, ``"repeat"``, ``"mirror"``.
        begin: 
            Start alignment of a linear gradient. Defaults to ``Alignment.topLeft``.
        end: 
            End alignment of a linear gradient. Defaults to ``Alignment.bottomRight``.
        center: 
            Centre point for radial and sweep gradients. Defaults to ``Alignment.center``.
        radius: 
            Radius for radial gradients, as a fraction of the shortest side. Defaults to ``0.5``.
        focal: 
            Focal point for radial gradients.
        focal_radius: 
            Radius of the focal circle for radial gradients.
        start_angle: 
            Start angle for sweep gradients, in degrees. Defaults to ``0``.
        end_angle: 
            End angle for sweep gradients, in degrees. Defaults to ``360``.
        start_degrees: 
            Alias for `start_angle`.
        end_degrees: 
            Alias for `end_angle`.
        bgcolor: 
            Background colour drawn behind the gradient.
        background: 
            Alias for `bgcolor`.
        background_color: 
            Alias for `bgcolor`.
        opacity: 
            Overall opacity applied via an ``Opacity`` widget, ``0.0``–``1.0``.
        mesh: 
            Mesh gradient data (experimental).
        mesh_points: 
            Alias for `mesh`.
        points: 
            Alias for `mesh`.
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
