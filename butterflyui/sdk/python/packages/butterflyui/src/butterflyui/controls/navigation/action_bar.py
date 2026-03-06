from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..items_control import ItemsControl
__all__ = ["ActionBar"]

@butterfly_control('action_bar')
class ActionBar(LayoutControl, ItemsControl):
    """
    Horizontal command surface for global and context-sensitive actions.

    Supports explicit ``items`` payloads and/or child controls. Item payloads
    may include icon descriptors and optional metadata so runtime events can
    carry command context.

    The control also participates in shared layout props used across navigation
    and overlay surfaces, including alignment/positioning, margin, size
    constraints, radius, and clip behavior.

    Example:

    ```python
    import butterflyui as bui

    bui.ActionBar(
        items=[
            {"id": "new", "icon": "add", "tooltip": "New"},
            {"id": "save", "icon": "save", "tooltip": "Save"},
        ],
        spacing=4,
        events=["action"],
    )
    ```
    """

    dense: bool | None = None
    """
    Reduces item height and padding.
    """

    spacing: float | None = None
    """
    Gap between items in logical pixels.
    """

    wrap: bool | None = None
    """
    When ``True`` items wrap onto a second line when space runs out.
    """

    context: Mapping[str, Any] | None = None
    """
    Arbitrary context payload associated with this action surface.
    """

    selection: list[Any] | Mapping[str, Any] | None = None
    """
    Selection payload (IDs or descriptors) used by contextual actions.
    """

    open: Any | None = None
    """
    Whether the control is currently open or visible.
    """

    position: Any | None = None
    """
    Position value forwarded to the `action_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    dismissible: Any | None = None
    """
    Whether the control can be dismissed by the user.
    """

    item_bgcolor: Any | None = None
    """
    Item bgcolor value forwarded to the `action_bar` runtime control.
    """

    backdrop: Any | None = None
    """
    Backdrop value forwarded to the `action_bar` runtime control.
    """

    backdrop_blur: Any | None = None
    """
    Backdrop blur value forwarded to the `action_bar` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `action_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `action_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `action_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `action_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `action_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `action_bar` runtime control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `action_bar` runtime control.
    """

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
