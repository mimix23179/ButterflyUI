from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ToastHost"]

class ToastHost(Component):
    """Host layer that manages and renders a queue of toast notifications.

    Renders a positioned overlay within the Flutter widget tree that displays
    multiple stacked toast items with configurable ordering and limits.

    Example:
        ```python
        host = ToastHost(position="bottom_center", max_items=3, latest_on_top=True)
        ```

    Args:
        items: List of toast item descriptors in the display queue.
        position: Screen corner or edge where toasts are stacked.
        max_items: Maximum number of toast items visible at once.
        latest_on_top: Whether newer toasts appear above older ones.
        dismissible: Whether individual toasts can be swiped away.
    """

    control_type = "toast_host"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        position: str | None = None,
        max_items: int | None = None,
        latest_on_top: bool | None = None,
        dismissible: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            toasts=items,
            position=position,
            max_items=max_items,
            latest_on_top=latest_on_top,
            dismissible=dismissible,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        payload = [dict(item) for item in items]
        return self.invoke(session, "set_items", {"items": payload, "toasts": payload})

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
