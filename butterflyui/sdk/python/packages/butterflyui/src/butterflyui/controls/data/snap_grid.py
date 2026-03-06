from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["SnapGrid"]

@butterfly_control('snap_grid')
class SnapGrid(LayoutControl):
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
    """

    show_grid: bool | None = None
    """
    Controls whether (default), the visual grid lines are painted. Set to ``False`` to hide the grid while keeping snapping. Set it to ``False`` to disable this behavior.
    """

    spacing: float | None = None
    """
    Major grid-cell spacing in logical pixels (clamped ``2`` – ``200``).  Defaults to ``16``.
    """

    subdivisions: int | None = None
    """
    Number of minor divisions within each major cell (clamped ``1`` – ``16``).  Defaults to ``1``.
    """

    line_color: Any | None = None
    """
    Colour of minor grid lines.  Defaults to ``#22FFFFFF``.
    """

    major_line_color: Any | None = None
    """
    Colour of major grid lines.  Defaults to ``#44FFFFFF``.
    """

    line_width: float | None = None
    """
    Stroke width of minor lines in logical pixels (clamped ``0.25`` – ``8``).  Defaults to ``1.0``.
    """

    major_line_width: float | None = None
    """
    Stroke width of major lines in logical pixels (clamped ``0.25`` – ``8``).  Defaults to ``1.2``.
    """

    background: Any | None = None
    """
    Background colour/paint applied behind the grid lines.
    """

    origin: Any | None = None
    """
    Grid origin point or offset configuration.
    """

    snap: bool | None = None
    """
    If ``True``, pointer coordinates are rounded to the nearest grid intersection.
    """

    snap_spacing: float | None = None
    """
    Snap interval in logical pixels (overrides ``spacing`` for snapping calculations).
    """

    snap_mode: str | None = None
    """
    Snap strategy hint forwarded to the runtime.
    """

    emit_on_hover: bool | None = None
    """
    If ``True``, emits ``"hover"`` events with ``x``/``y`` as the pointer moves over the grid.
    """

    emit_on_press: bool | None = None
    """
    If ``True``, emits ``"press"`` events with ``x``/``y`` on pointer down.
    """

    emit_on_drag: bool | None = None
    """
    If ``True``, emits ``"drag"`` events with ``x``/``y``/``dx``/``dy`` during drag gestures.
    """

    background_color: Any | None = None
    """
    Background color value forwarded to the `snap_grid` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `snap_grid` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `snap_grid` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `snap_grid` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `snap_grid` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `snap_grid` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `snap_grid` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `snap_grid` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `snap_grid` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `snap_grid` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `snap_grid` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `snap_grid` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `snap_grid` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `snap_grid` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `snap_grid` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `snap_grid` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `snap_grid` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `snap_grid` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `snap_grid` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
