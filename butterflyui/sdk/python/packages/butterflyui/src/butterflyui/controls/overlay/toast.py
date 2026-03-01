from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Toast"]

class Toast(Component):
    """Transient notification toast displayed briefly to the user.

    Renders a short-lived floating message within the Flutter widget tree with
    optional action and configurable visual style.

    Example:
        ```python
        t = Toast(message="File saved", open=True, duration_ms=2500)
        ```

    Args:
        message: Text content of the toast notification.
        open: Whether the toast is currently visible.
        duration_ms: Time in milliseconds before auto-dismissal.
        action_label: Label for the optional inline action button.
        variant: Visual style variant (e.g., info, success, warning, error).
    """

    control_type = "toast"

    def __init__(
        self,
        message: str | None = None,
        *,
        open: bool | None = None,
        duration_ms: int | None = None,
        action_label: str | None = None,
        variant: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            message=message,
            open=open,
            duration_ms=duration_ms,
            action_label=action_label,
            variant=variant,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def show(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": True})

    def hide(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": False})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
