from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["QuotedMessage"]

class QuotedMessage(Component):
    """Quoted reply block with a left-border accent.

    Renders a ``Container`` with a 3 px left ``Border`` accent line
    (using the theme divider colour) containing an optional
    ``author`` name, ``text`` body, and ``timestamp``.  When
    ``compact`` is ``True`` padding is reduced for inline use inside
    chat bubbles.

    Tapping the block emits ``"click"`` with the text, author, and
    timestamp payload.

    Example::

        import butterflyui as bui

        quote = bui.QuotedMessage(
            text="Let's meet at 3 PM.",
            author="Bob",
            timestamp="2:15 PM",
        )

    Args:
        text: 
            Quoted message body text.
        author: 
            Name of the original message author.
        timestamp: 
            Timestamp string for the original message.
        compact: 
            If ``True`` uses tighter padding for inline display.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "quoted_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        author: str | None = None,
        timestamp: str | None = None,
        compact: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            author=author,
            timestamp=timestamp,
            compact=compact,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
