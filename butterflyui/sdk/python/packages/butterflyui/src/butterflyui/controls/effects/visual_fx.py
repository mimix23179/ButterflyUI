from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["VisualFx"]


class VisualFx(Component):
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

    Args:
        child:
            The control to render and decorate with visual effect stages.
        glow:
            Mapping for glow stage parameters, such as color, blur radius,
            spread, intensity, and blend mode (renderer dependent).
        glass_blur:
            Mapping for glass/frosted stage parameters, typically blur sigma,
            tint color, and optional border/highlight knobs.
        chromatic_shift:
            Mapping for RGB shift/aberration stage parameters.
        gradient_sweep:
            Mapping for animated or static gradient sweep overlay parameters.
        enable_glow:
            Enables or disables the glow stage.
        enable_glass_blur:
            Enables or disables the glass blur stage.
        enable_chromatic_shift:
            Enables or disables the chromatic shift stage.
        enable_gradient_sweep:
            Enables or disables the gradient sweep stage.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
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

    control_type = "visual_fx"

    def __init__(
        self,
        child: Any | None = None,
        *,
        glow: Mapping[str, Any] | None = None,
        glass_blur: Mapping[str, Any] | None = None,
        chromatic_shift: Mapping[str, Any] | None = None,
        gradient_sweep: Mapping[str, Any] | None = None,
        enable_glow: bool | None = None,
        enable_glass_blur: bool | None = None,
        enable_chromatic_shift: bool | None = None,
        enable_gradient_sweep: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            glow=dict(glow) if glow is not None else None,
            glass_blur=dict(glass_blur) if glass_blur is not None else None,
            chromatic_shift=dict(chromatic_shift) if chromatic_shift is not None else None,
            gradient_sweep=dict(gradient_sweep) if gradient_sweep is not None else None,
            enable_glow=enable_glow,
            enable_glass_blur=enable_glass_blur,
            enable_chromatic_shift=enable_chromatic_shift,
            enable_gradient_sweep=enable_gradient_sweep,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
