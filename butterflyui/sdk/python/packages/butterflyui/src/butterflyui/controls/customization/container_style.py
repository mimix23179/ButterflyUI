from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ContainerStyle"]

@butterfly_control('container_style')
class ContainerStyle(LayoutControl):
    """
    Thin Styling helper that decorates a child surface through the
    shared Styling engine.

    The runtime resolves local style declarations, inline ``css`` blocks,
    stylesheet payloads, and optional scene layers before painting the
    resulting styled surface around the child content.

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

    animation: Any | None = None
    """
    Animation value forwarded to the `container_style` runtime control.
    """

    css: str | None = None
    """
    Inline CSS-like declaration block merged through the Styling engine.
    """

    stylesheet: str | Mapping[str, Any] | list[Any] | None = None
    """
    Stylesheet payload or CSS source resolved against this helper.
    """

    background_layers: list[Any] | None = None
    """
    Background scene-layer definitions rendered behind the styled surface.
    """

    foreground_layers: list[Any] | None = None
    """
    Foreground scene-layer definitions rendered above the styled surface.
    """

    lottie: Any = None
    """
    Lottie shorthand forwarded into the helper's overlay scene layers.
    """

    rive: Any = None
    """
    Rive shorthand forwarded into the helper's overlay scene layers.
    """

