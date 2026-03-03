from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Bubble"]


class Bubble(Component):
    """Composed message bubble that replaces mention/meta/quote micro-controls.

    ``Bubble`` can render message text, inline mention pills, quote blocks,
    metadata rows, divider labels, and reaction chips from one control.
    """

    control_type = "bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        author: str | None = None,
        timestamp: str | None = None,
        status: str | None = None,
        edited: bool | None = None,
        pinned: bool | None = None,
        divider_label: str | None = None,
        divider_color: Any | None = None,
        mention_label: str | None = None,
        mention_color: Any | None = None,
        mention_text_color: Any | None = None,
        mention_clickable: bool | None = None,
        quote_text: str | None = None,
        quote_author: str | None = None,
        quote_timestamp: str | None = None,
        quote_compact: bool | None = None,
        reactions: list[Any] | None = None,
        actions: list[Any] | None = None,
        compact: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            props=merge_props(
                props,
                text=text,
                title=title,
                subtitle=subtitle,
                author=author,
                timestamp=timestamp,
                status=status,
                edited=edited,
                pinned=pinned,
                divider_label=divider_label,
                divider_color=divider_color,
                mention_label=mention_label,
                mention_color=mention_color,
                mention_text_color=mention_text_color,
                mention_clickable=mention_clickable,
                quote_text=quote_text,
                quote_author=quote_author,
                quote_timestamp=quote_timestamp,
                quote_compact=quote_compact,
                reactions=reactions,
                actions=actions,
                compact=compact,
                dense=dense,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
