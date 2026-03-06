from __future__ import annotations

from collections.abc import Mapping, Sequence
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl


__all__ = ["ReorderableListView"]

@butterfly_control('reorderable_list_view')
class ReorderableListView(ScrollableControl):
    """
    Drag-and-drop list surface with runtime reorder state.

    ``ReorderableListView`` renders an ordered item collection that users can
    rearrange by dragging. Use :meth:`set_items` when the Python side needs to
    replace the current sequence, and subscribe to reorder-related events to
    persist the new order.

    ```python
    import butterflyui as bui

    lst = bui.ReorderableListView(
        items=[
            {"id": "a", "label": "Backlog"},
            {"id": "b", "label": "In Progress"},
            {"id": "c", "label": "Done"},
        ],
        events=["reorder", "change"],
    )
    ```
    """

    items: Sequence[Any] | None = None
    """
    Ordered item descriptors rendered by the list.
    """

    dense: bool | None = None
    """
    If ``True``, uses compact row spacing.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `reorderable_list_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `reorderable_list_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `reorderable_list_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `reorderable_list_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `reorderable_list_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `reorderable_list_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `reorderable_list_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `reorderable_list_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `reorderable_list_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `reorderable_list_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `reorderable_list_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `reorderable_list_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `reorderable_list_view` runtime control.
    """

    def set_items(self, session: Any, items: Sequence[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": list(items)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
