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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `drag_handle` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `drag_handle` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `drag_handle` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `drag_handle` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `drag_handle` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `drag_handle` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `drag_handle` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `drag_handle` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `drag_handle` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `drag_handle` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `drag_handle` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `drag_handle` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `drag_handle` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `drag_handle` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `drag_handle` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `drag_handle` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `drag_handle` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `drag_handle` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `drag_handle` runtime control.
    """
