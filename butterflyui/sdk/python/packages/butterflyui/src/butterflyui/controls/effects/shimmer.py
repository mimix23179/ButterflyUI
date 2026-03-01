from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from ._eventful_effect import _EventfulEffect

__all__ = ["Shimmer"]

class Shimmer(_EventfulEffect):
    """Animated shimmer gradient that sweeps across the child using a
    ``ShaderMask``.

    The Flutter runtime drives a ``LinearGradient`` highlight band
    across the child via an ``AnimationController`` in repeat mode.
    The gradient transitions from *base_color* through
    *highlight_color* and back, creating a loading-placeholder
    shimmer or a decorative glint effect.

    Example::

        import butterflyui as bui

        shim = bui.Shimmer(
            bui.Container(width=200, height=40),
            duration_ms=1200,
            angle=18,
            opacity=0.85,
        )

    Args:
        duration_ms: 
            Full sweep period in milliseconds.  Defaults to
            ``1200``; clamped to ``200 – 600 000``.
        angle: 
            Gradient rotation angle in **degrees**.  Defaults to
            ``18``.
        opacity: 
            Overall shimmer opacity (``0.0`` – ``1.0``).
            Defaults to ``0.85``.
        base_color: 
            Gradient base colour.  Defaults to the theme's
            ``surfaceContainerHighest`` at 45 % opacity.
        highlight_color: 
            Bright highlight band colour.  Defaults to
            the theme's ``surface`` at 75 % opacity.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "shimmer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        duration_ms: int | None = None,
        angle: float | None = None,
        opacity: float | None = None,
        base_color: Any | None = None,
        highlight_color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            duration_ms=duration_ms,
            angle=angle,
            opacity=opacity,
            base_color=base_color,
            highlight_color=highlight_color,
            **kwargs,
        )
