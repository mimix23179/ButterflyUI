from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FlowField"]

class FlowField(Component):
    """Animated vector flow-field visualisation rendered with a
    ``CustomPainter``.

    The Flutter runtime draws a grid of short line segments whose
    angles are derived from a sinusoidal noise function seeded by
    ``seed``.  An ``AnimationController`` running in an infinite loop
    continuously advances the time parameter so the field appears to
    ripple and flow.

    Example::

        import butterflyui as bui

        field = bui.FlowField(
            density=20,
            speed=0.5,
            line_width=1.5,
            color="#22d3ee",
            opacity=0.6,
        )

    Args:
        seed: 
            Integer seed that offsets the noise function, 
            producing a different field pattern.  Defaults to ``1``.
        density: 
            Spacing in logical pixels between grid points 
            (``8`` – ``120``).  Defaults to ``24``.
        speed: 
            Animation speed multiplier (``0.0`` – ``5.0``). 
            Defaults to ``0.35``.
        line_width: 
            Stroke width of each segment in logical pixels 
            (``0.2`` – ``8.0``).  Defaults to ``1.1``.
        color: 
            Stroke colour of the line segments.  
            Defaults to ``#22d3ee``.
        opacity: 
            Stroke opacity (``0.0`` – ``1.0``).  
            Defaults to ``0.6``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "flow_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        seed: int | None = None,
        density: float | None = None,
        speed: float | None = None,
        line_width: float | None = None,
        color: Any | None = None,
        opacity: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            seed=seed,
            density=density,
            speed=speed,
            line_width=line_width,
            color=color,
            opacity=opacity,
            **kwargs,
        )
