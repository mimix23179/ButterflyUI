from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Effects"]

class Effects(Component):
    """
    Composite visual-effects wrapper that applies blur, colour
    filtering, colour-matrix adjustments, and opacity to its children.
    
    The Flutter runtime applies effects in order: **Gaussian blur** →
    **colour filter** (``ColorFilter.mode``) → **colour-matrix filter**
    (brightness / contrast / saturation / grayscale via a 5×4
    ``ColorFilter.matrix``) → **opacity**.  When ``enabled`` is
    ``False`` the child is returned unmodified.
    
    Example:
    
    ```python
    import butterflyui as bui

    blurred = bui.Effects(
        bui.Image(src="photo.png"),
        blur=6.0,
        saturation=0.5,
        brightness=1.1,
        opacity=0.9,
    )
    ```
    """


    blur: float | None = None
    """
    Gaussian blur sigma applied equally in X and Y.
    Values ≤ 0 are ignored.
    """

    opacity: float | None = None
    """
    Layer opacity (``0.0`` – ``1.0``).
    Values ≥ 1 are ignored.
    """

    color: Any | None = None
    """
    Tint colour applied via ``ColorFilter.mode``.
    """

    blend_mode: str | None = None
    """
    Blend mode string used with *color* (e.g. ``"multiply"``,
    ``"screen"``, ``"overlay"``).  Defaults to ``"src_atop"``.
    """

    brightness: float | None = None
    """
    Brightness multiplier where ``1.0`` is unchanged.
    Internally shifts the colour-matrix offset channel.
    """

    contrast: float | None = None
    """
    Contrast multiplier where ``1.0`` is unchanged.
    """

    saturation: float | None = None
    """
    Saturation multiplier where ``1.0`` is unchanged and
    ``0.0`` is fully desaturated.
    """

    hue_rotate: float | None = None
    """
    Reserved — hue rotation angle in degrees.
    """

    grayscale: float | None = None
    """
    Grayscale mix (``0.0`` – ``1.0``) blended into the
    luminance-weighted colour matrix.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "effects"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        blur: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        blend_mode: str | None = None,
        brightness: float | None = None,
        contrast: float | None = None,
        saturation: float | None = None,
        hue_rotate: float | None = None,
        grayscale: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            blur=blur,
            opacity=opacity,
            color=color,
            blend_mode=blend_mode,
            brightness=brightness,
            contrast=contrast,
            saturation=saturation,
            hue_rotate=hue_rotate,
            grayscale=grayscale,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
