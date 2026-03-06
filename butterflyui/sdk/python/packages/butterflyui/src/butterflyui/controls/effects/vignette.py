from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Vignette"]

@butterfly_control('vignette')
class Vignette(EffectControl):
    """
    Radial vignette overlay that darkens the edges of the child
    content.

    The Flutter runtime renders a darkened radial gradient
    (``ButterflyUIVignette``) on top of the child.  The gradient
    fades from transparent at the centre to the configured *color* at
    the edges, with *intensity* controlling the gradient spread.

    Example:

    ```python
    import butterflyui as bui

    vig = bui.Vignette(
        bui.Image(src="landscape.png"),
        intensity=0.5,
        color="#000000",
    )
    ```
    """

    intensity: float | None = None
    """
    Vignette strength (``0.0`` transparent – ``1.0``
    opaque edges).  Defaults to ``0.45``.
    """

    color: Any | None = None
    """
    Edge colour of the vignette gradient.  Defaults to
    the theme's default scaffold/background colour.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    softness: Any | None = None
    """
    Softness value forwarded to the `vignette` runtime control.
    """

    blend_mode: Any | None = None
    """
    Blend mode value forwarded to the `vignette` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `vignette` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `vignette` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `vignette` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `vignette` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `vignette` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `vignette` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `vignette` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `vignette` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `vignette` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `vignette` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `vignette` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `vignette` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `vignette` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `vignette` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `vignette` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `vignette` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `vignette` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `vignette` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `vignette` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)
