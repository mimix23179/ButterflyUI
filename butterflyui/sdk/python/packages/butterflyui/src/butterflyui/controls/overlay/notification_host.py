from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .toast_host import ToastHost

__all__ = ["NotificationHost"]

class NotificationHost(ToastHost):
    """
    Overlay host that queues and displays dismissible notification banners.

    Extends ``ToastHost`` with richer notification styling and event
    emission. ``items`` populates the initial notification list.
    ``position`` anchors the stack to a screen corner. ``max_items`` caps
    the visible count. ``latest_on_top`` controls stack order.
    ``dismissible`` adds a close button on each notification.

    ```python
    import butterflyui as bui

    host = bui.NotificationHost(
        position="top_right",
        max_items=5,
        dismissible=True,
        events=["dismiss"],
    )
    ```

    Args:
        items:
            Initial list of notification spec mappings.
        position:
            Screen corner where the notification stack is anchored.
            Values: ``"top_left"``, ``"top_right"``, ``"bottom_left"``,
            ``"bottom_right"``.
        max_items:
            Maximum number of notifications shown simultaneously.
        latest_on_top:
            When ``True`` the most recent notification appears at the top
            of the stack.
        dismissible:
            When ``True`` each notification shows a close button.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "notification_host"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        position: str | None = None,
        max_items: int | None = None,
        latest_on_top: bool | None = None,
        dismissible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            items=items,
            position=position,
            max_items=max_items,
            latest_on_top=latest_on_top,
            dismissible=dismissible,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def push(self, session: Any, item: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "push", {"item": dict(item)})

    def dismiss(self, session: Any, item_id: str) -> dict[str, Any]:
        return self.invoke(session, "dismiss", {"id": item_id})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_items(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_items", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
