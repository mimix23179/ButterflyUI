from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["SubmitScope"]

class SubmitScope(Component):
    """
    Scope wrapper that intercepts Enter/Ctrl+Enter key presses and fires submit events.

    The runtime wraps its children with a keyboard listener that fires a
    submit action when the configured keys are pressed. ``enabled`` toggles
    the listener. ``submit_on_enter`` triggers on Enter; ``submit_on_ctrl_enter``
    triggers on Ctrl+Enter. ``debounce_ms`` throttles rapid submissions.
    ``payload`` attaches a static data mapping to each submit event.

    ```python
    import butterflyui as bui

    bui.SubmitScope(
        bui.TextInput(placeholder="Search…"),
        submit_on_enter=True,
        debounce_ms=300,
        events=["submit"],
    )
    ```

    Args:
        enabled:
            When ``True`` the submit keyboard listener is active.
        submit_on_enter:
            When ``True`` pressing Enter triggers the submit action.
        submit_on_ctrl_enter:
            When ``True`` pressing Ctrl+Enter triggers the submit action.
        debounce_ms:
            Minimum milliseconds between consecutive submit events.
        payload:
            Static mapping attached to every submit event payload.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "submit_scope"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        enabled: bool | None = None,
        submit_on_enter: bool | None = None,
        submit_on_ctrl_enter: bool | None = None,
        debounce_ms: int | None = None,
        payload: Mapping[str, Any] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            submit_on_enter=submit_on_enter,
            submit_on_ctrl_enter=submit_on_ctrl_enter,
            debounce_ms=debounce_ms,
            payload=dict(payload) if payload is not None else None,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def submit(self, session: Any, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "submit", {"payload": dict(payload or {})})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
