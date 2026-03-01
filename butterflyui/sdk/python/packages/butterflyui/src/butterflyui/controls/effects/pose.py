from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Pose"]

class Pose(Component):
    """Spatial transform that applies translation, uniform scale,
    Z-axis rotation, and opacity to a child widget.

    The Flutter runtime builds a ``Matrix4`` with ``translate(x, y, z)``
    → ``scale`` → ``rotateZ`` (degrees converted to radians) and wraps
    the result in an ``Opacity`` layer when opacity is below ``1.0``.

    Example::

        import butterflyui as bui

        posed = bui.Pose(
            bui.Icon(name="star"),
            x=10,
            y=-5,
            scale=1.2,
            rotate=45,
            opacity=0.8,
        )

    Args:
        x: 
            Horizontal translation in logical pixels.  Defaults to ``0``.
        y: 
            Vertical translation in logical pixels.  Defaults to ``0``.
        z: 
            Depth translation (Z-axis) in logical pixels.  Defaults to
            ``0``.
        scale: 
            Uniform scale factor.  Defaults to ``1.0``.
        rotate: 
            Rotation about the Z-axis in **degrees**.  The runtime
            converts to radians internally.  Defaults to ``0``.
        opacity: 
            Layer opacity (``0.0`` – ``1.0``).  Defaults to
            ``1.0``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "pose"

    def __init__(
        self,
        child: Any | None = None,
        *,
        x: float | None = None,
        y: float | None = None,
        z: float | None = None,
        scale: float | None = None,
        rotate: float | None = None,
        opacity: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            x=x,
            y=y,
            z=z,
            scale=scale,
            rotate=rotate,
            opacity=opacity,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
