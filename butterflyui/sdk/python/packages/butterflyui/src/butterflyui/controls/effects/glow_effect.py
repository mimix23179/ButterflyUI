from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["GlowEffect"]

@butterfly_control('glow_effect')
class GlowEffect(EffectControl):
    """
    Coloured glow (outer shadow) applied around a child widget via a
    ``BoxDecoration`` with a single ``BoxShadow``.

    The Flutter runtime wraps the child in a ``Container`` whose
    ``BoxDecoration`` contains a single ``BoxShadow`` with the
    configured colour, blur radius, spread, offset, and corner radius.
    The ``intensity`` multiplier scales the effective blur.

    Example:

    ```python
    import butterflyui as bui

    glow = bui.GlowEffect(
        bui.Container(width=120, height=120),
        color="#00ffff88",
        blur=16,
        spread=0,
        radius=12,
    )
    ```
    """

    color: Any | None = None
    """
    Glow colour.  Defaults to ``#8800FFFF`` (semi-transparent cyan).
    """

    blur: float | None = None
    """
    Base blur radius of the ``BoxShadow``.  Defaults to ``16``.
    """

    spread: float | None = None
    """
    Spread radius of the ``BoxShadow``.  Defaults to ``0``.
    """

    radius: float | None = None
    """
    Corner radius of the ``BoxDecoration``.  Defaults to ``12``.
    """

    offset_x: float | None = None
    """
    Horizontal shadow offset in logical pixels. Defaults to ``0``.
    """

    offset_y: float | None = None
    """
    Vertical shadow offset in logical pixels. Defaults to ``0``.
    """

    clip: bool | None = None
    """
    Reserved — whether to clip the glow to the container bounds.
    """

    intensity: float | None = None
    """
    Multiplier applied to *blur*
    (e.g. ``2.0`` doubles the effective blur radius).  Defaults to ``1``.
    """

    direction: Any | None = None
    """
    Alternative offset specified as a two-element list
    ``[x, y]``; overrides *offset_x* / *offset_y* when present.
    """

    animated: bool | None = None
    """
    Reserved — enable animated glow pulsing.
    """

    duration_ms: int | None = None
    """
    Animation duration in milliseconds when *animated* is enabled.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `glow_effect` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `glow_effect` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `glow_effect` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `glow_effect` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `glow_effect` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `glow_effect` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `glow_effect` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `glow_effect` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `glow_effect` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `glow_effect` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `glow_effect` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `glow_effect` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `glow_effect` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `glow_effect` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `glow_effect` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `glow_effect` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `glow_effect` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `glow_effect` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `glow_effect` runtime control.
    """

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)
