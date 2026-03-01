from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NoticeBar"]

class NoticeBar(Component):
    """
    Inline banner that displays a notice message with optional dismiss and action.

    The runtime renders a horizontal notification strip. ``variant`` sets
    the semantic color (``"info"``, ``"success"``, ``"warning"``, ``"error"``
    etc.). ``icon`` prepends an icon glyph. ``dismissible`` adds an ✕ button
    to close the bar. ``action_label`` and ``action_id`` add a text button
    that emits an action event.

    ```python
    import butterflyui as bui

    bui.NoticeBar(
        text="Your changes have been saved.",
        variant="success",
        dismissible=True,
        events=["dismiss", "action"],
    )
    ```

    Args:
        text:
            The notice message text.
        variant:
            Semantic color variant. Values: ``"info"``, ``"success"``,
            ``"warning"``, ``"error"``.
        icon:
            Icon glyph name prepended to the message.
        dismissible:
            When ``True`` an ✕ button is shown to dismiss the bar.
        action_label:
            Label for an optional inline action button.
        action_id:
            Identifier emitted when the action button is tapped.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "notice_bar"

    def __init__(
        self,
        *,
        text: str | None = None,
        variant: str | None = None,
        icon: str | None = None,
        dismissible: bool | None = None,
        action_label: str | None = None,
        action_id: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            variant=variant,
            icon=icon,
            dismissible=dismissible,
            action_label=action_label,
            action_id=action_id,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
