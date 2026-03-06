from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["GlassBlur"]

@butterfly_control('glass_blur', field_aliases={'content': 'child'})
class GlassBlur(EffectControl):
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

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    blur: float | None = None
    """
    Gaussian blur sigma applied to the backdrop.
    Defaults to ``14``.
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

    foreground: Any | None = None
    """
    Foreground value forwarded to the `glass_blur` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `glass_blur` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `glass_blur` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `glass_blur` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `glass_blur` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `glass_blur` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `glass_blur` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `glass_blur` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `glass_blur` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `glass_blur` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `glass_blur` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `glass_blur` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `glass_blur` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `glass_blur` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `glass_blur` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `glass_blur` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `glass_blur` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `glass_blur` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `glass_blur` runtime control.
    """

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
