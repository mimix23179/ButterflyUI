from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["NotificationCenter"]

@butterfly_control('notification_center')
class NotificationCenter(OverlayControl):
    """
    Scrollable panel listing persistent in-app notifications.

    The runtime renders a list of notification items that remain until
    explicitly dismissed or cleared. ``items``/``notifications`` supplies
    the notification specs. ``title`` labels the panel header.
    ``show_clear_all`` adds a button to dismiss all items at once.
    ``max_items`` limits the visible count.

    Example:

    ```python
    import butterflyui as bui

    nc = bui.NotificationCenter(
        title="Notifications",
        show_clear_all=True,
        max_items=50,
    )
    ```
    """

    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    notifications: list[Mapping[str, Any]] | None = None
    """
    Backward-compatible alias for ``items``. When both fields are provided, ``items`` takes precedence and this alias is kept only for compatibility.
    """

    title: str | None = None
    """
    Heading text displayed at the top of the panel.
    """

    show_clear_all: bool | None = None
    """
    When ``True`` a clear-all button is shown in the header.
    """

    max_items: int | None = None
    """
    Maximum number of notification items to retain.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `notification_center` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `notification_center` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `notification_center` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `notification_center` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `notification_center` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `notification_center` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `notification_center` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `notification_center` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `notification_center` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `notification_center` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `notification_center` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `notification_center` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `notification_center` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `notification_center` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `notification_center` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `notification_center` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `notification_center` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `notification_center` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `notification_center` runtime control.
    """

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})
