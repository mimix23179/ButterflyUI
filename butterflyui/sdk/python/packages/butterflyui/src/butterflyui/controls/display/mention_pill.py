from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MentionPill"]

class MentionPill(Component):
    """Rounded pill badge for @-mention labels.

    Renders a small rounded ``Container`` (border-radius 999) with a
    coloured background and contrasting text.  When ``clickable`` is
    ``True`` the pill is wrapped in an ``InkWell`` that emits
    ``"click"`` with the label payload.

    Example::

        import butterflyui as bui

        pill = bui.MentionPill(
            label="@alice",
            color="#2563eb",
            clickable=True,
        )

    Args:
        label: 
            Display text rendered inside the pill.
        color: 
            Background fill colour (defaults to ``#2563eb``).
        text_color: 
            Foreground text colour (defaults to white).
        clickable: 
            If ``True`` the pill emits ``"click"`` on tap.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "mention_pill"

    def __init__(
        self,
        label: str | None = None,
        *,
        color: Any | None = None,
        text_color: Any | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            color=color,
            text_color=text_color,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
