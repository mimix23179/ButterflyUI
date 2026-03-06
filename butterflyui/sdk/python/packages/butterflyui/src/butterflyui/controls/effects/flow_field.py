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

    color: Any | None = None
    """
    Stroke colour of the line segments.
    Defaults to ``#22d3ee``.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `flow_field` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `flow_field` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `flow_field` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `flow_field` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `flow_field` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `flow_field` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `flow_field` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `flow_field` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `flow_field` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `flow_field` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `flow_field` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `flow_field` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `flow_field` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `flow_field` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `flow_field` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `flow_field` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `flow_field` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `flow_field` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `flow_field` runtime control.
    """
