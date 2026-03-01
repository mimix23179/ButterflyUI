from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["EmptyState"]

class EmptyState(Component):
    """Placeholder displayed when a list or container has no items.

    Renders a centred column with an icon (defaults to
    ``Icons.inbox_outlined``), a bold ``title``, a descriptive
    ``message``, and an optional ``FilledButton`` whose label comes
    from ``action_label``.  Pressing the button emits an
    ``"action"`` event.

    Example::

        import butterflyui as bui

        empty = bui.EmptyState(
            title="No messages yet",
            message="Start a conversation to see messages here.",
            action_label="New Chat",
            icon="inbox_outlined",
        )

    Args:
        title: 
            Heading text (defaults to ``"Nothing here"``).
        message: 
            Descriptive body text below the title.
        action_label: 
            Label for the optional action button. When present the button emits ``"action"`` on press.
        icon: 
            Material icon name or code-point rendered above the title (defaults to ``inbox_outlined``).
    """
    control_type = "empty_state"

    def __init__(
        self,
        *,
        title: str | None = None,
        message: str | None = None,
        action_label: str | None = None,
        icon: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            action_label=action_label,
            icon=icon,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
