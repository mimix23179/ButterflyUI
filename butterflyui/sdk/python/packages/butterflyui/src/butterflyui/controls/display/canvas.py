from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Canvas"]

class Canvas(Component):
    """Drawable canvas surface for simple vector shapes.
    
    Renders a ``Container`` with a ``CustomPaint`` layer that draws
    lines, rectangles, and circles from the ``shapes`` list.  Each
    shape is a dict with a ``"type"`` key (``"line"``, ``"rect"``, or
    ``"circle"``) plus geometry keys such as ``x``, ``y``, ``width``/
    ``height`` or ``radius``, and optional ``color`` and ``stroke``.
    
    Tapping the canvas emits a ``"tap"`` event with ``x``/``y`` local
    coordinates.  Use ``set_shapes`` to replace the shape list,
    ``clear`` to remove all shapes, and ``get_state`` to retrieve
    the current shape count.
    
    Example::
    
        import butterflyui as bui
    
        canvas = bui.Canvas(
            shapes=[
                {"type": "rect", "x": 10, "y": 10, "width": 80, "height": 40, "color": "#2563eb"},
                {"type": "circle", "x": 60, "y": 60, "radius": 20, "color": "#7c3aed"},
            ],
            background="#0f172a",
        )
    
    Args:
        strokes:
            Ordered list of stroke descriptors rendered by the canvas surface.
        shapes:
            List of shape dicts drawn by the ``CustomPainter``. Each dict should contain ``"type"`` plus geometry keys.
        background:
            Background colour for the canvas container.
        grid:
            Controls whether a reference grid is drawn behind the shapes. Set it to ``False`` to disable this behavior.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
    """


    strokes: list[Mapping[str, Any]] | None = None
    """
    Ordered list of stroke descriptors rendered by the canvas surface.
    """

    shapes: list[Mapping[str, Any]] | None = None
    """
    List of shape dicts drawn by the ``CustomPainter``. Each dict should contain ``"type"`` plus geometry keys.
    """

    background: Any | None = None
    """
    Background colour for the canvas container.
    """

    grid: bool | None = None
    """
    Controls whether a reference grid is drawn behind the shapes. Set it to ``False`` to disable this behavior.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "canvas"

    def __init__(
        self,
        *,
        strokes: list[Mapping[str, Any]] | None = None,
        shapes: list[Mapping[str, Any]] | None = None,
        background: Any | None = None,
        grid: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            strokes=strokes,
            shapes=shapes,
            background=background,
            grid=grid,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_shapes(self, session: Any, shapes: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_shapes", {"shapes": [dict(shape) for shape in shapes]})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
