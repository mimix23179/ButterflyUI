from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NotificationCenter"]

class NotificationCenter(Component):
    """Notification centre panel for reviewing accumulated notifications.

    Renders a scrollable list of notification items within the Flutter widget
    tree, with optional bulk-clear functionality.

    Example:
        ```python
        center = NotificationCenter(title="Notifications", show_clear_all=True)
        ```

    Args:
        items: List of notification item descriptors to display.
        notifications: Alias for items; merged with items when both provided.
        title: Heading displayed above the notification list.
        show_clear_all: Whether to show a button clearing all notifications.
        max_items: Maximum number of notifications to render.
    """

    control_type = "notification_center"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        notifications: list[Mapping[str, Any]] | None = None,
        title: str | None = None,
        show_clear_all: bool | None = None,
        max_items: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items if items is not None else notifications,
            notifications=notifications if notifications is not None else items,
            title=title,
            show_clear_all=show_clear_all,
            max_items=max_items,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})
