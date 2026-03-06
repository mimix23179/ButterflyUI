from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["DragHandle"]

@butterfly_control('drag_handle')
class DragHandle(LayoutControl):
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

    Example:

    ```python
    import butterflyui as bui

    bui.DragHandle(
        bui.Icon("drag_indicator"),
        index=0,
        payload={"id": "item-0"},
        drag_type="list_item",
    )
    ```
    """

    index: int | None = None
    """
    Zero-based position of this handle in the parent
    reorderable list.
    """

    payload: Mapping[str, Any] | None = None
    """
    Arbitrary mapping attached to the drag and delivered
    to the drop target.
    """

    drag_type: str | None = None
    """
    String tag used to match compatible drop zones.
    """
