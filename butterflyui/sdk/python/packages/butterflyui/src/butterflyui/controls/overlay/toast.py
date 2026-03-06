from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Toast"]

class Toast(Component):
    """
    Ephemeral notification toast that appears briefly and auto-dismisses.
    
    The runtime renders a transient message overlay. ``message`` sets the
    notification text. ``open`` controls visibility. ``duration_ms`` sets
    the auto-dismiss delay. ``action_label`` adds an inline action button.
    ``variant`` applies a semantic color scheme.

    Example:
    
    ```python
    import butterflyui as bui
    
    bui.Toast(
        message="Changes saved!",
        open=True,
        duration_ms=3000,
        variant="success",
    )
    ```
    """


    open: bool | None = None
    """
    When ``True`` the toast is visible.
    """


    message: str | None = None
    """
    Main message text rendered inside the control.
    """

    duration_ms: int | None = None
    """
    Milliseconds before the toast auto-dismisses. Use ``0`` to
    disable auto-dismiss.
    """

    action_label: str | None = None
    """
    Label for an optional inline action button.
    """

    variant: str | None = None
    """
    Semantic color variant. Values: ``"info"``, ``"success"``,
    ``"warning"``, ``"error"``.
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
