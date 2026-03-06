from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Parallax"]

@butterfly_control('parallax', field_aliases={'content': 'child'})
class Parallax(EffectControl):
    """
    Mouse-tracked parallax offset effect that shifts the child in
    response to pointer position.

    The Flutter runtime wraps the child in a ``MouseRegion`` and
    computes a normalised − 1…+1 offset from the pointer position
    relative to the widget centre.  An ``AnimatedContainer`` smoothly
    translates the child by up to ``max_offset`` logical pixels in
    each direction.  On pointer exit the offset resets to zero (unless
    ``reset_on_exit`` is ``False``).

    Example:

    ```python
    import butterflyui as bui

    parallax = bui.Parallax(
        bui.Image(src="hero.png"),
        max_offset=20,
        reset_on_exit=True,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    max_offset: float | None = None
    """
    Maximum translation in logical pixels along each
    axis.  Defaults to ``14``; clamped to ``0 – 200``.
    """

    reset_on_exit: bool | None = None
    """
    When ``True`` (default) the offset smoothly
    resets to zero when the pointer leaves the widget.
    """

    depths: list[float] | None = None
    """
    Reserved — per-layer depth factors for multi-layer
    parallax.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `parallax` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `parallax` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `parallax` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `parallax` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `parallax` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `parallax` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `parallax` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `parallax` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `parallax` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `parallax` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `parallax` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `parallax` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `parallax` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `parallax` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `parallax` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `parallax` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `parallax` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `parallax` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `parallax` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
