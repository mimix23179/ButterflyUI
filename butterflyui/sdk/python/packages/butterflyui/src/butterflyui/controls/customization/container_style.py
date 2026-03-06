from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ContainerStyle"]

class ContainerStyle(Component):
    """Surface decorator that applies background, border, shadow, and
    corner-radius styling to a child control.
    
    The runtime wraps the child in a ``Container`` with a ``BoxDecoration``
    built from the supplied style properties. A ``BoxShadow`` is added when
    any shadow property is set. Gradient fills are supported alongside or
    instead of a flat background colour.
    
    ```python
    import butterflyui as bui
    
    bui.ContainerStyle(
        my_content,
        bgcolor="#1e293b",
        radius=12,
        shadow_blur=8,
        shadow_color="#00000040",
        content_padding=16,
    )
    ```
    
    Args:
        variant:
            Named style variant hint forwarded to the runtime.
        bgcolor:
            Background colour of the container.
        color:
            Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
        border_color:
            Colour of the container border. A border is only drawn when this is set.
        border_width:
            Width of the container border in logical pixels. Defaults to ``1``.
        radius:
            Corner radius for the ``BorderRadius``. Defaults to ``8``.
        shape:
            Container shape hint (e.g. ``"circle"``, ``"rectangle"``).
        outline_width:
            Width of an additional outline stroke outside the border.
        outline_color:
            Outline color rendered around the control independently of its main border.
        stroke_width:
            Backward-compatible alias for ``outline_width``. When both fields are provided, ``outline_width`` takes precedence and this alias is kept only for compatibility.
        stroke_color:
            Backward-compatible alias for ``outline_color``. When both fields are provided, ``outline_color`` takes precedence and this alias is kept only for compatibility.
        shadow_color:
            Color tint applied to the rendered shadow effect.
        shadow_blur:
            Blur radius of the ``BoxShadow``.
        shadow_dx:
            Horizontal offset of the ``BoxShadow``.
        shadow_dy:
            Vertical offset of the ``BoxShadow``.
        glow_color:
            Colour of a secondary glow shadow.
        glow_blur:
            Blur radius used when rendering the glow effect around the control.
        background:
            Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
        bg_color:
            Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
        content_padding:
            Inner padding of the container. Accepts a number, list, or dict. Defaults to ``8``.
        inner_padding:
            Backward-compatible alias for ``content_padding``. When both fields are provided, ``content_padding`` takes precedence and this alias is kept only for compatibility.
        icon_padding:
            Padding around any icon content inside the container.
        animation:
            Animation configuration dict (e.g. ``{"duration_ms": 200}``). Enables smooth transitions when style properties change.
    """


    variant: str | None = None
    """
    Named style variant hint forwarded to the runtime.
    """

    bgcolor: Any | None = None
    """
    Background colour of the container.
    """

    color: Any | None = None
    """
    Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
    """

    border_color: Any | None = None
    """
    Colour of the container border. A border is only drawn when this is set.
    """

    border_width: float | None = None
    """
    Width of the container border in logical pixels. Defaults to ``1``.
    """

    radius: float | None = None
    """
    Corner radius for the ``BorderRadius``. Defaults to ``8``.
    """

    shape: str | None = None
    """
    Container shape hint (e.g. ``"circle"``, ``"rectangle"``).
    """

    outline_width: float | None = None
    """
    Width of an additional outline stroke outside the border.
    """

    outline_color: Any | None = None
    """
    Outline color rendered around the control independently of its main border.
    """

    stroke_width: float | None = None
    """
    Backward-compatible alias for ``outline_width``. When both fields are provided, ``outline_width`` takes precedence and this alias is kept only for compatibility.
    """

    stroke_color: Any | None = None
    """
    Backward-compatible alias for ``outline_color``. When both fields are provided, ``outline_color`` takes precedence and this alias is kept only for compatibility.
    """

    shadow_color: Any | None = None
    """
    Color tint applied to the rendered shadow effect.
    """

    shadow_blur: float | None = None
    """
    Blur radius of the ``BoxShadow``.
    """

    shadow_dx: float | None = None
    """
    Horizontal offset of the ``BoxShadow``.
    """

    shadow_dy: float | None = None
    """
    Vertical offset of the ``BoxShadow``.
    """

    glow_color: Any | None = None
    """
    Colour of a secondary glow shadow.
    """

    glow_blur: float | None = None
    """
    Blur radius used when rendering the glow effect around the control.
    """

    background: Any | None = None
    """
    Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
    """

    bg_color: Any | None = None
    """
    Backward-compatible alias for ``bgcolor``. When both fields are provided, ``bgcolor`` takes precedence and this alias is kept only for compatibility.
    """

    content_padding: Any | None = None
    """
    Inner padding of the container. Accepts a number, list, or dict. Defaults to ``8``.
    """

    inner_padding: Any | None = None
    """
    Backward-compatible alias for ``content_padding``. When both fields are provided, ``content_padding`` takes precedence and this alias is kept only for compatibility.
    """

    icon_padding: Any | None = None
    """
    Padding around any icon content inside the container.
    """
    control_type = "container_style"

    def __init__(
        self,
        *children: Any,
        variant: str | None = None,
        bgcolor: Any | None = None,
        color: Any | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        radius: float | None = None,
        shape: str | None = None,
        outline_width: float | None = None,
        outline_color: Any | None = None,
        stroke_width: float | None = None,
        stroke_color: Any | None = None,
        shadow_color: Any | None = None,
        shadow_blur: float | None = None,
        shadow_dx: float | None = None,
        shadow_dy: float | None = None,
        glow_color: Any | None = None,
        glow_blur: float | None = None,
        background: Any | None = None,
        bg_color: Any | None = None,
        content_padding: Any | None = None,
        inner_padding: Any | None = None,
        icon_padding: Any | None = None,
        animation: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            bgcolor=bgcolor,
            color=color,
            border_color=border_color,
            border_width=border_width,
            radius=radius,
            shape=shape,
            outline_width=outline_width,
            outline_color=outline_color,
            stroke_width=stroke_width,
            stroke_color=stroke_color,
            shadow_color=shadow_color,
            shadow_blur=shadow_blur,
            shadow_dx=shadow_dx,
            shadow_dy=shadow_dy,
            glow_color=glow_color,
            glow_blur=glow_blur,
            background=background,
            bg_color=bg_color,
            content_padding=content_padding,
            inner_padding=inner_padding,
            icon_padding=icon_padding,
            animation=dict(animation) if animation is not None else None,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
