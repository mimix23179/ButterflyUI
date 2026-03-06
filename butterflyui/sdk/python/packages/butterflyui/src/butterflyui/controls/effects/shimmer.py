from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Shimmer"]

@butterfly_control('shimmer')
class Shimmer(EffectControl):
    """
    Animated shimmer gradient that sweeps across the child using a
    ``ShaderMask``.

    The Flutter runtime drives a ``LinearGradient`` highlight band
    across the child via an ``AnimationController`` in repeat mode.
    The gradient transitions from *base_color* through
    *highlight_color* and back, creating a loading-placeholder
    shimmer or a decorative glint effect.

    Example:

    ```python
    import butterflyui as bui

    shim = bui.Shimmer(
        bui.Container(width=200, height=40),
        duration_ms=1200,
        angle=18,
        opacity=0.85,
    )
    ```
    """

    duration_ms: int | None = None
    """
    Full sweep period in milliseconds.  Defaults to
    ``1200``; clamped to ``200 – 600 000``.
    """

    angle: float | None = None
    """
    Gradient rotation angle in **degrees**.  Defaults to
    ``18``.
    """

    base_color: Any | None = None
    """
    Gradient base colour.  Defaults to the theme's
    ``surfaceContainerHighest`` at 45 % opacity.
    """

    highlight_color: Any | None = None
    """
    Bright highlight band colour.  Defaults to
    the theme's ``surface`` at 75 % opacity.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `shimmer` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `shimmer` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `shimmer` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `shimmer` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `shimmer` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `shimmer` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `shimmer` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `shimmer` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `shimmer` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `shimmer` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `shimmer` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `shimmer` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `shimmer` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `shimmer` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `shimmer` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `shimmer` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `shimmer` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `shimmer` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `shimmer` runtime control.
    """
