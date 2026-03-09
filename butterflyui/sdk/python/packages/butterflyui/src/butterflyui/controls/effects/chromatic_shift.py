from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["ChromaticShift"]

@butterfly_control('chromatic_shift')
class ChromaticShift(EffectControl):
    """
    Chromatic aberration effect that renders offset red and blue
    colour-filtered copies of the child behind the original.

    The Flutter runtime stacks three layers: a red-tinted copy shifted
    by ``-shift`` pixels, a blue-tinted copy shifted by ``+shift``
    pixels, and the unmodified child on top.  The shift direction is
    governed by ``axis`` (``"x"`` or ``"y"``).

    Example:

    ```python
    import butterflyui as bui

    fx = bui.ChromaticShift(
        bui.Image(src="photo.png"),
        shift=2.5,
        opacity=0.35,
    )
    ```
    """

    shift: float | None = None
    """
    Pixel distance each colour channel is
    offset from the original.  Defaults to ``1.2``.
    """

    axis: str | None = None
    """
    Displacement axis — ``"x"`` (horizontal, default)
    or ``"y"`` (vertical).
    """

    red: Any | None = None
    """
    Colour used for the *red* channel ghost layer.
    Defaults to ``Colors.red``.
    """

    blue: Any | None = None
    """
    Colour used for the *blue* channel ghost layer.
    Defaults to ``Colors.blue``.
    """

    def set_shift(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_shift", {"value": float(value)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
