from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ScanlineOverlay"]

@butterfly_control('scanline_overlay', field_aliases={'content': 'child'})
class ScanlineOverlay(EffectControl):
    """
    CRT-style horizontal scanline overlay rendered on top of the
    child content.

    The Flutter runtime paints evenly-spaced horizontal lines using a
    custom ``ButterflyUIScanlineOverlay`` widget.  Line spacing,
    thickness, opacity, and colour are all configurable at creation
    time and can be updated at runtime via the ``set_style()`` invoke
    method.

    Example:

    ```python
    import butterflyui as bui

    crt = bui.ScanlineOverlay(
        bui.Image(src="retro.png"),
        spacing=6,
        thickness=1,
        opacity=0.18,
        color="#00ff00",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    spacing: float | None = None
    """
    Vertical distance between scanlines in logical pixels
    (``1`` – ``256``).  Defaults to ``6``.
    """

    thickness: float | None = None
    """
    Stroke thickness of each scanline (``0.5`` –
    ``32``).  Defaults to ``1``.
    """

    color: Any | None = None
    """
    Scanline colour.  Defaults to the current theme's
    text colour.
    """

    line_thickness: Any | None = None
    """
    Line thickness value forwarded to the `scanline_overlay` runtime control.
    """

    angle: Any | None = None
    """
    Angle value forwarded to the `scanline_overlay` runtime control.
    """

    speed: Any | None = None
    """
    Speed value forwarded to the `scanline_overlay` runtime control.
    """

    blend_mode: Any | None = None
    """
    Blend mode value forwarded to the `scanline_overlay` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `scanline_overlay` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `scanline_overlay` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `scanline_overlay` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `scanline_overlay` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `scanline_overlay` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `scanline_overlay` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `scanline_overlay` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `scanline_overlay` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `scanline_overlay` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `scanline_overlay` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `scanline_overlay` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `scanline_overlay` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `scanline_overlay` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `scanline_overlay` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `scanline_overlay` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `scanline_overlay` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `scanline_overlay` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `scanline_overlay` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `scanline_overlay` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
