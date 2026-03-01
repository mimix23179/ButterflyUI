from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SpanSlider"]

class SpanSlider(Component):
    """
    Two-handle range slider for selecting a start/end span.

    Renders a Flutter ``RangeSlider`` with separate ``start`` and
    ``end`` thumb handles.  Both handles are constrained by ``min``
    and ``max`` bounds.  Optional ``divisions`` add discrete snapping.
    When ``labels`` is ``True`` the current start/end values are shown
    in thumb tooltips while dragging.  Moving either handle emits a
    ``change`` event with ``{"start": ..., "end": ...}``.
    Use :meth:`set_value` to update both handles from Python.

    ```python
    import butterflyui as bui

    bui.SpanSlider(start=20.0, end=80.0, min=0.0, max=100.0)
    ```

    Args:
        start:
            Current position of the left (start) handle.
        end:
            Current position of the right (end) handle.
        min:
            Minimum bound of the slider range.
        max:
            Maximum bound of the slider range.
        divisions:
            Number of discrete segments.  Handles snap to boundaries.
        enabled:
            If ``False``, both handles are non-interactive.
        labels:
            If ``True``, current start/end values are shown in thumb
            tooltips while dragging.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "span_slider"

    def __init__(
        self,
        *,
        start: float | int | None = None,
        end: float | int | None = None,
        min: float | int | None = None,
        max: float | int | None = None,
        divisions: int | None = None,
        enabled: bool | None = None,
        labels: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            start=start,
            end=end,
            min=min,
            max=max,
            divisions=divisions,
            enabled=enabled,
            labels=labels,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, *, start: float | int, end: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"start": float(start), "end": float(end)})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
