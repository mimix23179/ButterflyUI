from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Pixelate"]

@butterfly_control('pixelate')
class Pixelate(EffectControl):
    """
    Pixelation effect achieved by cascading two ``Transform.scale``
    widgets with ``FilterQuality.none``.

    The Flutter runtime first scales the child down by a factor
    derived from ``amount`` (higher amounts = more pixelation), then
    scales it back up to its original size, both with nearest-neighbour
    filtering disabled.  The result is a retro mosaic / pixel-art
    look.

    Example:

    ```python
    import butterflyui as bui

    px = bui.Pixelate(
        bui.Image(src="photo.png"),
        amount=0.5,
    )
    ```
    """

    amount: float | None = None
    """
    Pixelation intensity (``0.0`` no effect – ``1.0``
    maximum).  Defaults to ``0.35``.  Internally mapped to a
    downscale factor ``1 − amount × 0.9``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `pixelate` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `pixelate` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `pixelate` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `pixelate` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `pixelate` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `pixelate` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `pixelate` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `pixelate` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `pixelate` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `pixelate` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `pixelate` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `pixelate` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `pixelate` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `pixelate` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `pixelate` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `pixelate` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `pixelate` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `pixelate` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `pixelate` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
