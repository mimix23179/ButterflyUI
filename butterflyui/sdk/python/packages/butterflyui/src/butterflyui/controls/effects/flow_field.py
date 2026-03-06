from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["FlowField"]

@butterfly_control('flow_field')
class FlowField(EffectControl):
    """
    Animated vector flow-field visualisation rendered with a
    ``CustomPainter``.

    The Flutter runtime draws a grid of short line segments whose
    angles are derived from a sinusoidal noise function seeded by
    ``seed``.  An ``AnimationController`` running in an infinite loop
    continuously advances the time parameter so the field appears to
    ripple and flow.

    Example:

    ```python
    import butterflyui as bui

    field = bui.FlowField(
        density=20,
        speed=0.5,
        line_width=1.5,
        color="#22d3ee",
        opacity=0.6,
    )
    ```
    """

    seed: int | None = None
    """
    Integer seed that offsets the noise function,
    producing a different field pattern.  Defaults to ``1``.
    """

    speed: float | None = None
    """
    Animation speed multiplier (``0.0`` – ``5.0``).
    Defaults to ``0.35``.
    """

    line_width: float | None = None
    """
    Stroke width of each segment in logical pixels
    (``0.2`` – ``8.0``).  Defaults to ``1.1``.
    """
