from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CurveEditor"]

class CurveEditor(Component):
    """
    Interactive curve / spline editor painted on a ``CustomPaint`` canvas.

    Control points are normalised ``{"x": 0–1, "y": 0–1}`` dicts,
    auto-sorted by ``x``. Tapping the canvas adds points (when
    `allow_add` is ``True``), and dragging moves them. A background grid
    is shown by default. Useful for defining easing curves, colour
    ramps, or value-mapping splines.

    ```python
    import butterflyui as bui

    bui.CurveEditor(
        points=[{"x": 0, "y": 0}, {"x": 0.5, "y": 0.8}, {"x": 1, "y": 1}],
        color="#06b6d4",
        height=180,
    )
    ```

    Args:
        points: 
            List of control points, each ``{"x": float, "y": float}`` in ``[0, 1]``. Auto-sorted by ``x``.
        color: 
            Line and point colour. Defaults to cyan (``"#00bcd4"``).
        show_grid: 
            If ``True`` (default), a background reference grid is drawn.
        show_points: 
            If ``True``, control-point handles are visible.
        allow_add: 
            If ``True``, tapping the canvas adds a new control point.
        allow_remove: 
            If ``True``, a point can be removed (e.g. via context menu or double-tap).
        line_width: 
            Stroke width of the curve line in logical pixels.
        point_size: 
            Radius of control-point handles in logical pixels.
        height: 
            Fixed height of the editor canvas. Defaults to ``180``.
        enabled: 
            If ``False``, the editor is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "curve_editor"

    def __init__(
        self,
        *,
        points: list[Mapping[str, Any]] | None = None,
        color: Any | None = None,
        show_grid: bool | None = None,
        show_points: bool | None = None,
        allow_add: bool | None = None,
        allow_remove: bool | None = None,
        line_width: float | None = None,
        point_size: float | None = None,
        height: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            points=[dict(point) for point in (points or [])],
            color=color,
            show_grid=show_grid,
            show_points=show_points,
            allow_add=allow_add,
            allow_remove=allow_remove,
            line_width=line_width,
            point_size=point_size,
            height=height,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_points(self, session: Any, points: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_points", {"points": [dict(point) for point in points]})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
