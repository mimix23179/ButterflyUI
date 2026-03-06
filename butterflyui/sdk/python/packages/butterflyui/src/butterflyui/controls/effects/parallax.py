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

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
