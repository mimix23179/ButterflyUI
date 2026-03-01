from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ArtifactCard"]

class ArtifactCard(Component):
    """Structured output card for displaying generated artifacts.

    Renders a Material ``Card`` with a bold title, body message, and optional
    action button.  When ``clickable`` is enabled the entire card is wrapped
    in an ``InkWell`` that emits a ``"tap"`` event.  The action button is a
    ``TextButton`` that emits ``"action"`` when pressed.  Child controls
    are placed below the message text inside the card body.

    Use ``set_content`` to update the title and message programmatically
    after the card is created, and ``emit`` to fire arbitrary custom events.

    Example::

        import butterflyui as bui

        card = bui.ArtifactCard(
            title="Analysis Complete",
            message="3 issues found in your code.",
            action_label="View Details",
            clickable=True,
        )

    Args:
        title: 
            Bold heading text displayed at the top of the card.
        message: 
            Body text rendered beneath the title.
        variant: 
            Visual variant key forwarded to the runtime theme.
        label: 
            Optional short label displayed alongside the title.
        action_label: 
            Text for the action ``TextButton`` at the bottom. When present the button emits ``"action"`` on click.
        clickable: 
            If ``True`` the whole card is wrapped in an ``InkWell`` that emits ``"tap"`` on press.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "artifact_card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        message: str | None = None,
        variant: str | None = None,
        label: str | None = None,
        action_label: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            variant=variant,
            label=label,
            action_label=action_label,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_content(self, session: Any, *, title: str | None = None, message: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if title is not None:
            payload["title"] = title
        if message is not None:
            payload["message"] = message
        return self.invoke(session, "set_content", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
