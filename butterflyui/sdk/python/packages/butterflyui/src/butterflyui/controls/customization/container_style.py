from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["ContainerStyle"]

@butterfly_control('container_style')
class ContainerStyle(LayoutControl):
    """
    Surface decorator that applies background, border, shadow, and
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

    animation: Any | None = None
    """
    Animation value forwarded to the `container_style` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `container_style` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `container_style` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `container_style` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `container_style` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `container_style` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `container_style` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `container_style` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `container_style` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `container_style` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `container_style` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `container_style` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `container_style` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `container_style` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `container_style` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `container_style` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `container_style` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `container_style` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `container_style` runtime control.
    """

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
