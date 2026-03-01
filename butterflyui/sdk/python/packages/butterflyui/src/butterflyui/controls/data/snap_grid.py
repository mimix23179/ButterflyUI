from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SnapGrid"]

class SnapGrid(Component):
    """
    Interactive grid overlay with major/minor lines, optional snapping,
    and pointer-event emission for hover, press, and drag.

    The runtime paints a ``CustomPaint`` grid using ``_GridPainter``
    with configurable ``spacing`` (major cell size, clamped 2–200 lp),
    ``subdivisions`` (minor lines per major cell, clamped 1–16),
    ``line_color``/``major_line_color``, and ``line_width``/
    ``major_line_width``.  A ``background`` colour fills behind the
    grid.  Child controls are composited on top via a ``Stack``.
    When ``emit_on_hover``, ``emit_on_press``, or ``emit_on_drag`` is
    ``True`` the corresponding pointer coordinates are sent as
    ``"hover"``, ``"press"``, or ``"drag"`` events.

    ```python
    import butterflyui as bui

    bui.SnapGrid(
        bui.Text("Canvas content"),
        show_grid=True,
        spacing=32,
        subdivisions=4,
        snap=True,
        emit_on_press=True,
    )
    ```

    Args:
        show_grid: 
            If ``True`` (default), the visual grid lines are painted.  Set to ``False`` to hide the grid while keeping snapping.
        spacing: 
            Major grid-cell spacing in logical pixels (clamped ``2`` – ``200``).  Defaults to ``16``.
        subdivisions: 
            Number of minor divisions within each major cell (clamped ``1`` – ``16``).  Defaults to ``1``.
        line_color: 
            Colour of minor grid lines.  Defaults to ``#22FFFFFF``.
        major_line_color: 
            Colour of major grid lines.  Defaults to ``#44FFFFFF``.
        line_width: 
            Stroke width of minor lines in logical pixels (clamped ``0.25`` – ``8``).  Defaults to ``1.0``.
        major_line_width: 
            Stroke width of major lines in logical pixels (clamped ``0.25`` – ``8``).  Defaults to ``1.2``.
        background: 
            Background colour/paint applied behind the grid lines.
        origin: 
            Grid origin point or offset configuration.
        snap: 
            If ``True``, pointer coordinates are rounded to the nearest grid intersection.
        snap_spacing: 
            Snap interval in logical pixels (overrides ``spacing`` for snapping calculations).
        snap_mode: 
            Snap strategy hint forwarded to the runtime.
        enabled: 
            If ``False``, pointer interaction is disabled.
        emit_on_hover: 
            If ``True``, emits ``"hover"`` events with ``x``/``y`` as the pointer moves over the grid.
        emit_on_press: 
            If ``True``, emits ``"press"`` events with ``x``/``y`` on pointer down.
        emit_on_drag: 
            If ``True``, emits ``"drag"`` events with ``x``/``y``/``dx``/``dy`` during drag gestures.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "snap_grid"

    def __init__(
        self,
        *children: Any,
        show_grid: bool | None = None,
        spacing: float | None = None,
        subdivisions: int | None = None,
        line_color: Any | None = None,
        major_line_color: Any | None = None,
        line_width: float | None = None,
        major_line_width: float | None = None,
        background: Any | None = None,
        origin: Any | None = None,
        snap: bool | None = None,
        snap_spacing: float | None = None,
        snap_mode: str | None = None,
        enabled: bool | None = None,
        emit_on_hover: bool | None = None,
        emit_on_press: bool | None = None,
        emit_on_drag: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            show_grid=show_grid,
            spacing=spacing,
            subdivisions=subdivisions,
            line_color=line_color,
            major_line_color=major_line_color,
            line_width=line_width,
            major_line_width=major_line_width,
            background=background,
            origin=origin,
            snap=snap,
            snap_spacing=snap_spacing,
            snap_mode=snap_mode,
            enabled=enabled,
            emit_on_hover=emit_on_hover,
            emit_on_press=emit_on_press,
            emit_on_drag=emit_on_drag,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
