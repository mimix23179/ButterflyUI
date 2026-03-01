from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SkeletonLoader"]

class SkeletonLoader(Component):
    """
    Multi-row skeleton placeholder that repeats shimmer rows vertically
    for list-like loading states.

    Renders ``count`` skeleton rows separated by ``spacing`` logical
    pixels.  Each row inherits the shape (``variant``), corner radius,
    dimensions, and shimmer ``duration_ms`` from the parameters below.
    Use ``set_count()`` to adjust the number of placeholder rows at
    runtime.

    ```python
    import butterflyui as bui

    bui.SkeletonLoader(
        count=5,
        spacing=8,
        variant="rect",
        width=300,
        height=16,
        radius=4,
    )
    ```

    Args:
        count: 
            Number of skeleton placeholder rows to render.
        spacing: 
            Vertical spacing in logical pixels between adjacent rows.
        variant: 
            Placeholder shape variant applied to each row (e.g. ``"rect"``, ``"circle"``).
        radius: 
            Corner radius in logical pixels for each placeholder row.
        width: 
            Width of each placeholder row in logical pixels.
        height: 
            Height of each placeholder row in logical pixels.
        duration_ms: 
            Duration of one full shimmer sweep cycle in milliseconds, applied to every row.
    """

    control_type = "skeleton_loader"

    def __init__(
        self,
        *,
        count: int | None = None,
        spacing: float | None = None,
        variant: str | None = None,
        radius: float | None = None,
        width: float | None = None,
        height: float | None = None,
        duration_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            count=count,
            spacing=spacing,
            variant=variant,
            radius=radius,
            width=width,
            height=height,
            duration_ms=duration_ms,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_count(self, session: Any, count: int) -> dict[str, Any]:
        return self.invoke(session, "set_count", {"count": int(count)})
