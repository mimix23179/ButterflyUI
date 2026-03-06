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

    notifications: list[Mapping[str, Any]] | None = None
    """
    Backward-compatible alias for ``items``. When both fields are provided, ``items`` takes precedence and this alias is kept only for compatibility.
    """

    show_clear_all: bool | None = None
    """
    When ``True`` a clear-all button is shown in the header.
    """

    max_items: int | None = None
    """
    Maximum number of notification items to retain.
    """

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})
