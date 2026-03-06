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
