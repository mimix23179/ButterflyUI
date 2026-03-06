from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ChromaticShift"]

@butterfly_control('chromatic_shift')
class ChromaticShift(EffectControl):
    """
    Chromatic aberration effect that renders offset red and blue
    colour-filtered copies of the child behind the original.

    The Flutter runtime stacks three layers: a red-tinted copy shifted
    by ``-shift`` pixels, a blue-tinted copy shifted by ``+shift``
    pixels, and the unmodified child on top.  The shift direction is
    governed by ``axis`` (``"x"`` or ``"y"``).

    Example:

    ```python
    import butterflyui as bui

    fx = bui.ChromaticShift(
        bui.Image(src="photo.png"),
        shift=2.5,
        opacity=0.35,
    )
    ```
    """

    shift: float | None = None
    """
    Pixel distance each colour channel is
    offset from the original.  Defaults to ``1.2``.
    """

    axis: str | None = None
    """
    Displacement axis — ``"x"`` (horizontal, default)
    or ``"y"`` (vertical).
    """

    red: Any | None = None
    """
    Colour used for the *red* channel ghost layer.
    Defaults to ``Colors.red``.
    """

    blue: Any | None = None
    """
    Colour used for the *blue* channel ghost layer.
    Defaults to ``Colors.blue``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `chromatic_shift` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `chromatic_shift` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `chromatic_shift` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `chromatic_shift` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `chromatic_shift` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `chromatic_shift` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `chromatic_shift` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `chromatic_shift` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `chromatic_shift` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `chromatic_shift` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `chromatic_shift` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `chromatic_shift` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `chromatic_shift` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `chromatic_shift` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `chromatic_shift` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `chromatic_shift` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `chromatic_shift` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `chromatic_shift` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `chromatic_shift` runtime control.
    """

    def set_shift(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_shift", {"value": float(value)})

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
