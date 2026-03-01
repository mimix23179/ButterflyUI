from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DragPayload"]

class DragPayload(Component):
    """
    Makes its child draggable and attaches an arbitrary data payload.

    The Flutter runtime wraps the child in a ``Draggable`` widget.
    While dragging, the original child becomes semi-transparent
    (``opacity: 0.45``) and a full-opacity ``Material`` feedback
    widget follows the pointer.  The ``data`` value is delivered to
    any ``DropZone`` the drag is released on.  ``drag_type`` and
    ``mime`` type hints allow drop zones to selectively accept or
    reject the drag.  ``axis`` constrains movement to a single
    direction.  Lifecycle events ``drag_start``, ``drag_end``, and
    ``drag_cancel`` are emitted automatically.

    ```python
    import butterflyui as bui

    bui.DragPayload(
        bui.Card(bui.Text("Drag me")),
        data={"id": "task-42"},
        drag_type="task",
    )
    ```

    Args:
        data:
            Payload delivered to the drop target on a successful drop.
        drag_type:
            String tag used to match compatible :class:`DropZone`
            targets.
        mime:
            MIME type hint for desktop drag-and-drop interoperability.
        axis:
            Constrains drag direction — ``"horizontal"``,
            ``"vertical"``, or ``None`` for free movement.
        max_simultaneous:
            Maximum number of concurrent drag operations allowed.
        drag_anchor:
            Where the feedback widget is anchored relative to the
            pointer — e.g. ``"pointer"`` or ``"childCenter"``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "drag_payload"

    def __init__(
        self,
        child: Any | None = None,
        *,
        data: Any | None = None,
        drag_type: str | None = None,
        mime: str | None = None,
        axis: str | None = None,
        max_simultaneous: int | None = None,
        drag_anchor: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            data=data,
            drag_type=drag_type,
            mime=mime,
            axis=axis,
            max_simultaneous=max_simultaneous,
            drag_anchor=drag_anchor,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
