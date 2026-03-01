from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["AnimatedBackground"]

class AnimatedBackground(Component):
    """Animated color-cycling background that continuously blends through a
    list of colours.

    The Flutter runtime layers each colour as a full-size ``Container``
    inside a ``Stack``, fading successive layers in and out over a
    configurable duration using a ``CurvedAnimation`` driven by an
    ``AnimationController``.  When only one colour is supplied the
    widget short-circuits to a static ``Container``.

    Example::

        import butterflyui as bui

        bg = bui.AnimatedBackground(
            colors=["#22d3ee", "#a78bfa", "#f472b6"],
            duration_ms=3000,
        )

    Args:
        colors: 
            Sequence of colour values (hex strings, integers, or
            any format accepted by the runtime ``coerceColor`` 
            helper that the background cycles through.
        duration_ms: 
            Total cycle duration in milliseconds.  Defaults to ``2400``; 
            clamped to the range ``1 – 600 000``.
    """
    control_type = "animated_background"

    def __init__(
        self,
        child: Any | None = None,
        *,
        colors: list[Any] | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            colors=colors,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
