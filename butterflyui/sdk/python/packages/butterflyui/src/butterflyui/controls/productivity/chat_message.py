from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ChatMessage"]

class ChatMessage(Component):
    """
    A single chat message item with author metadata and interaction support.

    The runtime renders one message row within a chat thread. ``text`` is
    the message body. ``role`` identifies the author type (e.g. ``"user"``,
    ``"assistant"``). ``name`` displays a human-readable author name.
    ``timestamp`` shows a send-time label. ``status`` reflects delivery
    state. ``avatar`` sets a URL or icon identifier for the author avatar.
    ``align`` controls horizontal placement. ``grouped`` suppresses the
    avatar when adjacent messages share an author. ``clickable`` enables
    tap events.

    ```python
    import butterflyui as bui

    bui.ChatMessage(
        text="Hello!",
        role="user",
        name="Alice",
        align="right",
        events=["click"],
    )
    ```

    Args:
        text:
            The message body text.
        role:
            Author role identifier, e.g. ``"user"`` or ``"assistant"``.
        name:
            Human-readable display name of the message author.
        timestamp:
            Timestamp string displayed below the message.
        status:
            Delivery status label, e.g. ``"sent"``, ``"delivered"``.
        avatar:
            URL or icon identifier for the author avatar image.
        align:
            Horizontal alignment. Values: ``"left"``, ``"right"``.
        grouped:
            When ``True`` the avatar is hidden to tighten grouped messages.
        clickable:
            When ``True`` the message row emits tap events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "chat_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        timestamp: str | None = None,
        status: str | None = None,
        avatar: str | None = None,
        align: str | None = None,
        grouped: bool | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            value=text,
            role=role,
            name=name,
            timestamp=timestamp,
            status=status,
            avatar=avatar,
            align=align,
            grouped=grouped,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
