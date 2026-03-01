from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Modal"]

class Modal(Component):
    """Modal dialog overlay that blocks interaction with background content.

    Renders a centred dialog within the Flutter widget tree with optional
    transition and focus-trap behaviour.

    Example:
        ```python
        dialog = Modal(open=True, dismissible=True, close_on_escape=True)
        ```

    Args:
        open: Whether the modal is currently visible.
        dismissible: Whether clicking the scrim dismisses the modal.
        close_on_escape: Whether pressing Escape closes the modal.
        trap_focus: Whether keyboard focus is confined inside the modal.
        duration_ms: Transition duration in milliseconds.
        transition: Named transition to use when opening or closing.
        transition_type: Category of transition animation to apply.
        source_rect: Origin rectangle used for shared-element transitions.
    """

    control_type = "modal"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        dismissible: bool | None = None,
        close_on_escape: bool | None = None,
        trap_focus: bool | None = None,
        duration_ms: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        source_rect: Mapping[str, Any] | list[float] | tuple[float, ...] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            dismissible=dismissible,
            close_on_escape=close_on_escape,
            trap_focus=trap_focus,
            duration_ms=duration_ms,
            transition=transition,
            transition_type=transition_type,
            source_rect=source_rect,
            **kwargs,
        )
        super().__init__(
            child=child,
            props=merged,
            style=style,
            strict=strict,
        )

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
