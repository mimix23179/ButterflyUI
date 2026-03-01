from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Skeleton"]

class Skeleton(Component):
    """
    Animated shimmer placeholder used while content is loading.

    The runtime renders a rounded ``Container`` that plays a shimmer
    sweep animation.  The shape is controlled by ``variant`` (e.g.
    ``"rect"``, ``"circle"``), corner rounding by ``radius``, and
    shimmer timing by ``duration_ms``.  ``color`` sets the base
    skeleton fill while ``highlight_color`` tints the sweeping
    highlight.  Call ``start()`` / ``stop()`` via invoke to
    control the animation at runtime.

    ```python
    import butterflyui as bui

    bui.Skeleton(
        variant="rect",
        width=200,
        height=20,
        radius=4,
        duration_ms=1200,
    )
    ```

    Args:
        variant: 
            Placeholder shape variant — e.g. ``"rect"``, ``"circle"``.  Determines the clip shape of the shimmer.
        radius: 
            Corner radius in logical pixels applied to the placeholder shape.
        width: 
            Placeholder width in logical pixels.
        height: 
            Placeholder height in logical pixels.
        duration_ms: 
            Duration of one full shimmer sweep cycle in milliseconds.
        color: 
            Base fill colour of the skeleton surface.
        highlight_color: 
            Colour of the shimmer highlight that sweeps across the surface.
    """

    control_type = "skeleton"

    def __init__(
        self,
        *,
        variant: str | None = None,
        radius: float | None = None,
        width: float | None = None,
        height: float | None = None,
        duration_ms: int | None = None,
        color: Any | None = None,
        highlight_color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            variant=variant,
            radius=radius,
            width=width,
            height=height,
            duration_ms=duration_ms,
            color=color,
            highlight_color=highlight_color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def start(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "start", {})

    def stop(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "stop", {})
