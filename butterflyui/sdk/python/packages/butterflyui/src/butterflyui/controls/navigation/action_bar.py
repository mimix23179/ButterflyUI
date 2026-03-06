from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["ActionBar"]

@butterfly_control('action_bar')
class ActionBar(LayoutControl):
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

    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
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

    bgcolor: Any | None = None
    """
    Background fill color of the bar.
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

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `action_bar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `action_bar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `action_bar` runtime control.
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `action_bar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `action_bar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `action_bar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `action_bar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `action_bar` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `action_bar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `action_bar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `action_bar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `action_bar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `action_bar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `action_bar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `action_bar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `action_bar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `action_bar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `action_bar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `action_bar` runtime control.
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

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `action_bar` runtime control.
    """

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
