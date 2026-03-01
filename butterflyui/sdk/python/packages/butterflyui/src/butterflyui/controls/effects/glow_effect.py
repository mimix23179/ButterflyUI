from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GlowEffect"]

class GlowEffect(Component):
    """Coloured glow (outer shadow) applied around a child widget via a
    ``BoxDecoration`` with a single ``BoxShadow``.

    The Flutter runtime wraps the child in a ``Container`` whose
    ``BoxDecoration`` contains a single ``BoxShadow`` with the
    configured colour, blur radius, spread, offset, and corner radius.
    The ``intensity`` multiplier scales the effective blur.

    Example::

        import butterflyui as bui

        glow = bui.GlowEffect(
            bui.Container(width=120, height=120),
            color="#00ffff88",
            blur=16,
            spread=0,
            radius=12,
        )

    Args:

        color: 
            Glow colour.  Defaults to ``#8800FFFF`` (semi-transparent cyan).
        blur: 
            Base blur radius of the ``BoxShadow``.  Defaults to ``16``.
        spread: 
            Spread radius of the ``BoxShadow``.  Defaults to ``0``.
        radius: 
            Corner radius of the ``BoxDecoration``.  Defaults to ``12``.
        offset_x: 
            Horizontal shadow offset in logical pixels. Defaults to ``0``.
        offset_y: 
            Vertical shadow offset in logical pixels. Defaults to ``0``.
        clip: 
            Reserved — whether to clip the glow to the container bounds.
        intensity: 
            Multiplier applied to *blur* 
            (e.g. ``2.0`` doubles the effective blur radius).  Defaults to ``1``.
        direction: 
            Alternative offset specified as a two-element list 
            ``[x, y]``; overrides *offset_x* / *offset_y* when present.
        animated: 
            Reserved — enable animated glow pulsing.
        duration_ms: 
            Animation duration in milliseconds when *animated* is enabled.
    """
    control_type = "glow_effect"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        blur: float | None = None,
        spread: float | None = None,
        radius: float | None = None,
        offset_x: float | None = None,
        offset_y: float | None = None,
        clip: bool | None = None,
        intensity: float | None = None,
        direction: Any | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            blur=blur,
            spread=spread,
            radius=radius,
            offset_x=offset_x,
            offset_y=offset_y,
            clip=clip,
            intensity=intensity,
            direction=direction,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def trigger(self, session: Any, **payload: Any) -> dict[str, Any]:
        return self.invoke(session, "trigger", payload)
