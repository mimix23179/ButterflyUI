from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RulersOverlay"]

class RulersOverlay(Component):
    """
    Full rulers, grid overlay, and guide lines over a working surface.

    The runtime uses ``LayoutBuilder`` to draw top and left ruler gutters
    (``20`` px wide) with tick marks at every ``10`` px and longer ticks
    at every ``50`` px. An optional pixel grid is drawn at `grid_size`
    intervals. Vertical and horizontal guide lines are added via
    `guides_x` / `guides_y`.

    ```python
    import butterflyui as bui

    bui.RulersOverlay(
        my_canvas,
        show_rulers=True,
        show_grid=True,
        grid_size=16,
        guides_x=[100.0, 300.0],
        guides_y=[50.0],
    )
    ```

    Args:
        guides_x: 
            List of vertical guide-line positions in logical pixels.
        guides_y: 
            List of horizontal guide-line positions in logical pixels.
        show_rulers: 
            If ``True`` (default), the top and left ruler gutters (``20`` px) are drawn with tick marks.
        show_grid: 
            If ``True``, a pixel grid is drawn over the content area.
        grid_size: 
            Grid cell size in logical pixels. Defaults to ``16``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "rulers_overlay"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        guides_x: list[float] | None = None,
        guides_y: list[float] | None = None,
        show_rulers: bool | None = None,
        show_grid: bool | None = None,
        grid_size: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            guides_x=guides_x,
            guides_y=guides_y,
            show_rulers=show_rulers,
            show_grid=show_grid,
            grid_size=grid_size,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_guides(self, session: Any, guides_x: list[float], guides_y: list[float]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_guides",
            {"guides_x": [float(v) for v in guides_x], "guides_y": [float(v) for v in guides_y]},
        )

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
