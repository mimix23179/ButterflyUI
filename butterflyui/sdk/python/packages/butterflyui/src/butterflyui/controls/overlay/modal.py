from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Modal"]

class Modal(Component):
    """
    Fullscreen or centered modal dialog with optional animated transition.

    The runtime renders a modal overlay above all other content. ``open``
    controls visibility. ``dismissible`` allows closing by tapping outside
    or pressing Escape. ``close_on_escape`` specifically enables Escape-key
    dismissal. ``trap_focus`` locks keyboard focus inside the modal.
    ``transition_type`` and ``duration_ms`` configure the open/close
    animation; ``source_rect`` enables a shared-element expand transition.

    ```python
    import butterflyui as bui

    bui.Modal(
        bui.Text("Dialog body"),
        open=True,
        dismissible=True,
        transition_type="fade",
        duration_ms=200,
    )
    ```

    Args:
        open:
            When ``True`` the modal is visible.
        dismissible:
            When ``True`` tapping outside the modal closes it.
        close_on_escape:
            When ``True`` pressing Escape closes the modal.
        trap_focus:
            When ``True`` keyboard focus is confined inside the modal.
        duration_ms:
            Duration of the open/close animation in milliseconds.
        transition:
            Explicit transition spec mapping.
        transition_type:
            Named animation type for open/close. Values: ``"fade"``,
            ``"slide"``, ``"scale"``, ``"expand"``.
        source_rect:
            Source rectangle for a shared-element expand transition.
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
