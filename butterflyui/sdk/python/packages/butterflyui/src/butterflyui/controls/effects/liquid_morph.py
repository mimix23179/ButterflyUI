from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["LiquidMorph"]

@butterfly_control('liquid_morph')
class LiquidMorph(EffectControl):
    """
    Animated border-radius morph that transitions between a minimum
    and maximum corner radius using ``AnimatedContainer``.

    The Flutter runtime wraps the child in an ``AnimatedContainer``
    with ``Clip.antiAlias`` and a ``BoxDecoration`` whose
    ``borderRadius`` animates between *min_radius* and *max_radius*.
    When ``animate`` is ``False`` the radius snaps to *min_radius*.

    Example:

    ```python
    import butterflyui as bui

    morph = bui.LiquidMorph(
        bui.Container(width=100, height=100, color="#22d3ee"),
        min_radius=8,
        max_radius=32,
        duration_ms=1500,
    )
    ```
    """

    min_radius: float | None = None
    """
    Corner radius when *animate* is ``False`` or at
    the animation start.  Defaults to ``8``.
    """

    max_radius: float | None = None
    """
    Corner radius the animation targets.  Defaults
    to ``24``.
    """

    duration_ms: int | None = None
    """
    Transition duration in milliseconds.  Defaults
    to ``1200``; clamped to ``1 – 600 000``.
    """

    animate: bool | None = None
    """
    When ``True`` (default) the radius animates to
    *max_radius*; when ``False`` it stays at *min_radius*.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `liquid_morph` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `liquid_morph` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `liquid_morph` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `liquid_morph` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `liquid_morph` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `liquid_morph` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `liquid_morph` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `liquid_morph` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `liquid_morph` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `liquid_morph` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `liquid_morph` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `liquid_morph` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `liquid_morph` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `liquid_morph` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `liquid_morph` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `liquid_morph` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `liquid_morph` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `liquid_morph` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `liquid_morph` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
