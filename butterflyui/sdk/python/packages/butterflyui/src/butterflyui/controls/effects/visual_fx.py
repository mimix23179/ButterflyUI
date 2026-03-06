from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["VisualFx"]

@butterfly_control('visual_fx')
class VisualFx(EffectControl):
    """
    Composite visual-effects pipeline for staged post-processing around one child.

    ``VisualFx`` wraps a single child control and applies optional visual
    processing stages such as glow, glass blur, chromatic shift, and gradient
    sweep. Each stage accepts a mapping so advanced parameters can be forwarded
    directly to the Flutter renderer without changing this Python API.

    Stages are merged into outgoing ``props`` as plain JSON-like objects:
    ``glow``, ``glass_blur``, ``chromatic_shift``, and ``gradient_sweep``.
    Corresponding ``enable_*`` flags can be used to toggle stages on/off at
    runtime while retaining the stage configuration payload.

    ```python
    import butterflyui as bui

    fx = bui.VisualFx(
        child=bui.Container(
            bui.Text("Neon Card"),
            padding=16,
            radius=14,
            bgcolor="#10131d",
        ),
        glow={"color": "#5eead4", "radius": 18, "intensity": 0.75},
        glass_blur={"sigma_x": 10, "sigma_y": 10, "tint": "#66ffffff"},
        chromatic_shift={"amount": 1.2},
        gradient_sweep={"angle": 35, "opacity": 0.22},
        enable_glow=True,
        enable_glass_blur=True,
        enable_chromatic_shift=False,
        enable_gradient_sweep=True,
    )
    ```
    """

    glow: Mapping[str, Any] | None = None
    """
    Mapping for glow stage parameters, such as color, blur radius,
    spread, intensity, and blend mode (renderer dependent).
    """

    glass_blur: Mapping[str, Any] | None = None
    """
    Mapping for glass/frosted stage parameters, typically blur sigma,
    tint color, and optional border/highlight knobs.
    """

    chromatic_shift: Mapping[str, Any] | None = None
    """
    Mapping for RGB shift/aberration stage parameters.
    """

    gradient_sweep: Mapping[str, Any] | None = None
    """
    Mapping for animated or static gradient sweep overlay parameters.
    """

    enable_glow: bool | None = None
    """
    Enables or disables the glow stage.
    """

    enable_glass_blur: bool | None = None
    """
    Enables or disables the glass blur stage.
    """

    enable_chromatic_shift: bool | None = None
    """
    Enables or disables the chromatic shift stage.
    """

    enable_gradient_sweep: bool | None = None
    """
    Enables or disables the gradient sweep stage.
    """
