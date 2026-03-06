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
