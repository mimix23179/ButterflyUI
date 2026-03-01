from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NotificationCenter"]

class NotificationCenter(Component):
    """
    Scrollable panel listing persistent in-app notifications.

    The runtime renders a list of notification items that remain until
    explicitly dismissed or cleared. ``items``/``notifications`` supplies
    the notification specs. ``title`` labels the panel header.
    ``show_clear_all`` adds a button to dismiss all items at once.
    ``max_items`` limits the visible count.

    ```python
    import butterflyui as bui

    nc = bui.NotificationCenter(
        title="Notifications",
        show_clear_all=True,
        max_items=50,
    )
    ```

    Args:
        items:
            List of notification spec mappings. Alias for
            ``notifications``.
        notifications:
            Alias for ``items``.
        title:
            Heading text displayed at the top of the panel.
        show_clear_all:
            When ``True`` a clear-all button is shown in the header.
        max_items:
            Maximum number of notification items to retain.
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
