from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Canvas"]

@butterfly_control('canvas')
class Canvas(LayoutControl):
    """
    Drawable canvas surface for simple vector shapes.

    Renders a ``Container`` with a ``CustomPaint`` layer that draws
    lines, rectangles, and circles from the ``shapes`` list.  Each
    shape is a dict with a ``"type"`` key (``"line"``, ``"rect"``, or
    ``"circle"``) plus geometry keys such as ``x``, ``y``, ``width``/
    ``height`` or ``radius``, and optional ``color`` and ``stroke``.

    Tapping the canvas emits a ``"tap"`` event with ``x``/``y`` local
    coordinates.  Use ``set_shapes`` to replace the shape list,
    ``clear`` to remove all shapes, and ``get_state`` to retrieve
    the current shape count.

    Example:

    ```python
    import butterflyui as bui

    canvas = bui.Canvas(
        shapes=[
            {"type": "rect", "x": 10, "y": 10, "width": 80, "height": 40, "color": "#2563eb"},
            {"type": "circle", "x": 60, "y": 60, "radius": 20, "color": "#7c3aed"},
        ],
        background="#0f172a",
    )
    ```
    """

    strokes: list[Mapping[str, Any]] | None = None
    """
    Ordered list of stroke descriptors rendered by the canvas surface.
    """

    shapes: list[Mapping[str, Any]] | None = None
    """
    List of shape dicts drawn by the ``CustomPainter``. Each dict should contain ``"type"`` plus geometry keys.
    """

    grid: bool | None = None
    """
    Controls whether a reference grid is drawn behind the shapes. Set it to ``False`` to disable this behavior.
    """

    def set_shapes(self, session: Any, shapes: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_shapes", {"shapes": [dict(shape) for shape in shapes]})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
