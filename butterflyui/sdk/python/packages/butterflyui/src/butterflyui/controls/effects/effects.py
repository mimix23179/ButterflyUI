from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Effects"]


class Effects(Component):
    """
    Thin Styling helper that applies filter-style effects and authored
    render layers to its child content.

    The Flutter runtime resolves local ``style`` mappings, inline
    ``css`` declarations, stylesheet payloads, and optional Lottie /
    Rive shorthands through the shared Styling engine before running the
    helper's blur, tint, color-matrix, opacity, and scene-layer passes.
    """

    blur: float | None = None
    """
    Gaussian blur sigma applied equally in X and Y.
    """

    opacity: float | None = None
    """
    Layer opacity in the ``0.0`` to ``1.0`` range.
    """

    color: Any | None = None
    """
    Tint color applied through the helper's blend-mode filter path.
    """

    blend_mode: str | None = None
    """
    Blend mode token used when applying ``color``.
    """

    brightness: float | None = None
    """
    Brightness multiplier forwarded into the color-matrix stage.
    """

    contrast: float | None = None
    """
    Contrast multiplier forwarded into the color-matrix stage.
    """

    saturation: float | None = None
    """
    Saturation multiplier forwarded into the color-matrix stage.
    """

    hue_rotate: float | None = None
    """
    Reserved hue-rotation value in degrees.
    """

    grayscale: float | None = None
    """
    Grayscale mix blended into the helper's color-matrix filter.
    """

    css: str | None = None
    """
    Inline CSS-like declaration block resolved through ButterflyUI Styling.
    """

    stylesheet: str | Mapping[str, Any] | list[Any] | None = None
    """
    Stylesheet payload or CSS source applied to this helper before rendering.
    """

    background_layers: list[Any] | None = None
    """
    Background scene-layer definitions rendered behind the child content.
    """

    foreground_layers: list[Any] | None = None
    """
    Foreground scene-layer definitions rendered above the child content.
    """

    lottie: Any = None
    """
    Lottie shorthand converted into an overlay scene layer by the runtime.
    """

    rive: Any = None
    """
    Rive shorthand converted into an overlay scene layer by the runtime.
    """

    events: list[str] | None = None
    """
    Runtime event names that should be emitted back to Python.
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
        css: str | None = None,
        stylesheet: str | Mapping[str, Any] | list[Any] | None = None,
        background_layers: list[Any] | None = None,
        foreground_layers: list[Any] | None = None,
        lottie: Any = None,
        rive: Any = None,
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
            css=css,
            stylesheet=stylesheet,
            background_layers=background_layers,
            foreground_layers=foreground_layers,
            lottie=lottie,
            rive=rive,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
