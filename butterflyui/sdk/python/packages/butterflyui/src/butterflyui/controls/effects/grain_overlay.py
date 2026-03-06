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
