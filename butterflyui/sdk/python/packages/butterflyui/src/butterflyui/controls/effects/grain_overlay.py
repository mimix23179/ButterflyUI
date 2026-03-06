from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["GrainOverlay"]

@butterfly_control('grain_overlay', field_aliases={'content': 'child'})
class GrainOverlay(EffectControl):
    """
    Film-grain noise texture overlay rendered with a ``CustomPainter``.

    The Flutter runtime paints randomly positioned single-pixel
    rectangles over the child using a seeded ``Random`` instance.  The
    dot count is derived from the widget area multiplied by ``density``.
    An optional ``animated`` flag increments the seed each frame for a
    flickering grain effect.

    Example:

    ```python
    import butterflyui as bui

    grain = bui.GrainOverlay(
        bui.Image(src="photo.png"),
        opacity=0.08,
        density=0.45,
        color="#ffffff",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    seed: int | None = None
    """
    Integer seed for the pseudo-random number generator.
    Defaults to ``0``.
    """

    color: Any | None = None
    """
    Colour of the grain dots.  Defaults to white.
    """

    animated: bool | None = None
    """
    When ``True`` the seed auto-increments to produce
    flickering grain.
    """

    fps: int | None = None
    """
    Target frames per second for the animated grain
    refresh.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `grain_overlay` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `grain_overlay` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `grain_overlay` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `grain_overlay` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `grain_overlay` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `grain_overlay` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `grain_overlay` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `grain_overlay` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `grain_overlay` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `grain_overlay` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `grain_overlay` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `grain_overlay` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `grain_overlay` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `grain_overlay` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `grain_overlay` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `grain_overlay` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `grain_overlay` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `grain_overlay` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `grain_overlay` runtime control.
    """
