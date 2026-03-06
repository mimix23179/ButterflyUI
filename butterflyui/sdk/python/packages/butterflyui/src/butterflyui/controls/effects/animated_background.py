from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["AnimatedBackground"]

@butterfly_control('animated_background', field_aliases={'content': 'child'})
class AnimatedBackground(EffectControl):
    """
    Animated color-cycling background that continuously blends through a
    list of colours.

    The Flutter runtime layers each colour as a full-size ``Container``
    inside a ``Stack``, fading successive layers in and out over a
    configurable duration using a ``CurvedAnimation`` driven by an
    ``AnimationController``.  When only one colour is supplied the
    widget short-circuits to a static ``Container``.

    Example:

    ```python
    import butterflyui as bui

    bg = bui.AnimatedBackground(
        colors=["#22d3ee", "#a78bfa", "#f472b6"],
        duration_ms=3000,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    colors: list[Any] | None = None
    """
    Sequence of colour values (hex strings, integers, or
    any format accepted by the runtime ``coerceColor``
    helper that the background cycles through.
    """

    duration_ms: int | None = None
    """
    Total cycle duration in milliseconds.  Defaults to ``2400``;
    clamped to the range ``1 – 600 000``.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `animated_background` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `animated_background` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `animated_background` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `animated_background` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `animated_background` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `animated_background` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `animated_background` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `animated_background` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `animated_background` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `animated_background` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `animated_background` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `animated_background` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `animated_background` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `animated_background` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `animated_background` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `animated_background` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `animated_background` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `animated_background` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `animated_background` runtime control.
    """
