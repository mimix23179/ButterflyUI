from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..effect_control import EffectControl

__all__ = ["Pixelate"]

@butterfly_control('pixelate')
class Pixelate(EffectControl):
    """
    Pixelation effect achieved by cascading two ``Transform.scale``
    widgets with ``FilterQuality.none``.

    The Flutter runtime first scales the child down by a factor
    derived from ``amount`` (higher amounts = more pixelation), then
    scales it back up to its original size, both with nearest-neighbour
    filtering disabled.  The result is a retro mosaic / pixel-art
    look.

    Example:

    ```python
    import butterflyui as bui

    px = bui.Pixelate(
        bui.Image(src="photo.png"),
        amount=0.5,
    )
    ```
    """

    amount: float | None = None
    """
    Pixelation intensity (``0.0`` no effect – ``1.0``
    maximum).  Defaults to ``0.35``.  Internally mapped to a
    downscale factor ``1 − amount × 0.9``.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
