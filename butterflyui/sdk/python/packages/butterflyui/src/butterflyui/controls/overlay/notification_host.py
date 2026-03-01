from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .toast_host import ToastHost

__all__ = ["NotificationHost"]

class NotificationHost(ToastHost):
    """Host layer that manages and displays queued notification toasts.

    Extends ToastHost to provide a notification-specific overlay within the
    Flutter widget tree, with positional stacking and event support.

    Example:
        ```python
        host = NotificationHost(position="top_right", max_items=5)
        ```

    Args:
        items: List of notification item descriptors in the queue.
        position: Screen corner or edge where notifications appear.
        max_items: Maximum notifications visible at once.
        latest_on_top: Whether newer notifications stack above older ones.
        dismissible: Whether individual notifications can be swiped away.
        events: Flutter client events to subscribe to.
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
