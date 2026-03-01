from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TypingIndicator"]

class TypingIndicator(Component):
    """Animated typing dots used in chat interfaces.

    Renders a horizontal ``Row`` of small circular dots (default
    count 3, size 8 px) in the given ``color``.  The dots are
    intended to animate in the runtime to indicate that another
    user is typing.

    Example::

        import butterflyui as bui

        dots = bui.TypingIndicator(count=3, color="#9ca3af")

    Args:
        text: 
            Optional descriptive text (e.g. ``"Alice is typing"``).
        count: 
            Number of dots to display (default ``3``, clamped 1\u20136).
        speed_ms: 
            Animation speed in milliseconds.
        dot_size: 
            Diameter of each dot in logical pixels.
        color: 
            Dot fill colour.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "typing_indicator"

    def __init__(
        self,
        *,
        text: str | None = None,
        count: int | None = None,
        speed_ms: int | None = None,
        dot_size: float | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            count=count,
            speed_ms=speed_ms,
            dot_size=dot_size,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
