from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DragHandle"]

class DragHandle(Component):
    """
    Marks its child as an individual drag handle within a reorderable list.

    Wraps the child in a drag-feedback region that the parent
    reorderable container recognises by ``index``.  An optional
    ``payload`` mapping is attached to the drag operation so the
    drop target can identify what was moved.  When ``drag_type`` is
    set, only ``DropZone`` instances that accept that type will
    respond to the drag.  Drag lifecycle events (``drag_start``,
    ``drag_end``, ``drag_cancel``) are emitted when the gesture
    starts, ends, or is cancelled.

    ```python
    import butterflyui as bui

    bui.DragHandle(
        bui.Icon("drag_indicator"),
        index=0,
        payload={"id": "item-0"},
        drag_type="list_item",
    )
    ```

    Args:
        index:
            Zero-based position of this handle in the parent
            reorderable list.
        enabled:
            If ``False``, dragging is disabled.
        payload:
            Arbitrary mapping attached to the drag and delivered
            to the drop target.
        drag_type:
            String tag used to match compatible drop zones.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "drag_handle"

    def __init__(
        self,
        child: Any | None = None,
        *,
        index: int | None = None,
        enabled: bool | None = None,
        payload: Mapping[str, Any] | None = None,
        drag_type: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            index=index,
            enabled=enabled,
            payload=dict(payload or {}),
            drag_type=drag_type,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)
