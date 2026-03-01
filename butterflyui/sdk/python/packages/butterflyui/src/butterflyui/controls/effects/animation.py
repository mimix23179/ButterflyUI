from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Animation"]

class Animation(Component):
    """Tween-based entrance animation that interpolates opacity, scale,
    rotation, and translation offset from zero to the specified target
    values.

    The Flutter runtime wraps the child in a
    ``TweenAnimationBuilder<double>`` (0 → 1) and applies transforms in
    the order *translate → rotate → scale → opacity*.  When ``enabled``
    is ``False`` the child is rendered immediately without animation.

    Example::

        import butterflyui as bui

        anim = bui.Animation(
            bui.Text("Hello"),
            duration_ms=400,
            opacity=0.0,
            scale=0.8,
            curve="ease_out_cubic",
        )

    Args:
        duration_ms: 
            Animation duration in milliseconds.  
            Defaults to ``220``; clamped to ``1 – 600 000``.
        curve: 
            Named easing curve (e.g. ``"linear"``, ``"ease_in_out"``, ``"ease_out_cubic"``).  
            Defaults to ``ease_out_cubic``.
        opacity: 
            Target opacity the child animates *toward* (``0.0`` –``1.0``).  
            Defaults to ``1.0`` (fully opaque, i.e. no opacity change).
        scale: 
            Target uniform scale factor (``0.001`` – ``10.0``).  
            Defaults to ``1.0``.
        offset: 
            Target translation offset as a two-element list 
            ``[x, y]`` or a mapping ``{"x": …, "y": …}``.
        rotation: 
            Target rotation in **degrees**.  
            The runtime converts to radians internally.
        enabled: 
            Set to ``False`` 
            to bypass the animation entirely and render the child immediately.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "animation"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        duration_ms: int | None = None,
        curve: str | None = None,
        opacity: float | None = None,
        scale: float | None = None,
        offset: Any | None = None,
        rotation: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            duration_ms=duration_ms,
            curve=curve,
            opacity=opacity,
            scale=scale,
            offset=offset,
            rotation=rotation,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
