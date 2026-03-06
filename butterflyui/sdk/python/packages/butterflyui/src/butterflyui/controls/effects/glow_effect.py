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

    blur: float | None = None
    """
    Base blur radius of the ``BoxShadow``.  Defaults to ``16``.
    """

    spread: float | None = None
    """
    Spread radius of the ``BoxShadow``.  Defaults to ``0``.
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

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)
