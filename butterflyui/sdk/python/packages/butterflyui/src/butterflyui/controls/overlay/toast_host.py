from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ToastHost"]

class ToastHost(Component):
    """
    Container that manages and displays a stack of toast notifications.

    The runtime maintains a queue of toast items, rendering them at a
    specified screen corner. ``position`` anchors the stack.
    ``max_items`` limits simultaneously displayed toasts. ``latest_on_top``
    controls stack order. ``dismissible`` adds a close button to each toast.
    Use ``push`` to add toasts, ``dismiss`` to remove one by ID, and
    ``clear`` to remove all.

    ```python
    import butterflyui as bui

    host = bui.ToastHost(
        position="bottom_right",
        max_items=3,
        dismissible=True,
    )
    ```

    Args:
        items:
            Initial list of toast spec mappings.
        position:
            Screen corner where the toast stack is anchored. Values:
            ``"top_left"``, ``"top_right"``, ``"bottom_left"``,
            ``"bottom_right"``.
        max_items:
            Maximum number of toasts shown simultaneously.
        latest_on_top:
            When ``True`` the newest toast appears at the top of the stack.
        dismissible:
            When ``True`` each toast shows a close button.
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
