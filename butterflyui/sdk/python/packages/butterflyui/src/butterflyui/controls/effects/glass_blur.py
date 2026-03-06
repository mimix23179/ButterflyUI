from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GlassBlur"]

class GlassBlur(Component):
    """
    Frosted-glass blur panel built from a ``BackdropFilter`` with an
    optional tinted overlay, rounded corners, border glow, and a
    subtle noise texture.
    
    The Flutter runtime clips the child to a ``ClipRRect``, applies a
    Gaussian ``BackdropFilter`` blur, then paints a semi-transparent
    colour fill, optional border, optional glow ``BoxShadow``, and an
    optional noise overlay via a ``CustomPaint`` painter.
    
    Example:
    
    ```python
    import butterflyui as bui

    glass = bui.GlassBlur(
        bui.Text("Hello"),
        blur=14,
        opacity=0.16,
        radius=12,
        border_color="#ffffff40",
    )
    ```
    """


    blur: float | None = None
    """
    Gaussian blur sigma applied to the backdrop.
    Defaults to ``14``.
    """

    opacity: float | None = None
    """
    Opacity of the tinted colour fill (``0.0`` – ``1.0``).
    Defaults to ``0.16``.
    """

    color: Any | None = None
    """
    Fill colour composited on top of the blur.
    Defaults to white.
    """

    radius: float | None = None
    """
    Corner radius of the clipping ``RRect`` and ``BoxDecoration``.
    Defaults to ``12``.
    """

    border_color: Any | None = None
    """
    Optional border colour drawn around the glass panel.
    """

    border_width: float | None = None
    """
    Stroke width of the border in logical pixels.
    Defaults to ``1``.
    """

    noise_opacity: float | None = None
    """
    Opacity of the random-dot noise texture overlay (``0.0`` – ``1.0``).
    ``0`` disables the texture.
    """

    border_glow: Any | None = None
    """
    Optional colour for an outer glow
    ``BoxShadow`` rendered behind the panel.
    """
    control_type = "glass_blur"

    def __init__(
        self,
        child: Any | None = None,
        *,
        blur: float | None = None,
        opacity: float | None = None,
        color: Any | None = None,
        radius: float | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        noise_opacity: float | None = None,
        border_glow: Any | None = None,
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
            radius=radius,
            border_color=border_color,
            border_width=border_width,
            noise_opacity=noise_opacity,
            border_glow=border_glow,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
