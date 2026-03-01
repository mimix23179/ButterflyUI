from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .chat_message import ChatMessage

__all__ = ["ChatBubble"]

class ChatBubble(ChatMessage):
    """
    Bubble-style chat message with a rounded background and optional avatar.

    A specialization of ``ChatMessage`` rendered in the classic chat-bubble
    style. Inherits all ``ChatMessage`` properties.

    ```python
    import butterflyui as bui

    bui.ChatBubble(
        text="Hey, how are you?",
        role="user",
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
            When ``True`` the bubble emits tap events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "chat_bubble"

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
        super().__init__(
            text=text,
            role=role,
            name=name,
            timestamp=timestamp,
            status=status,
            avatar=avatar,
            align=align,
            grouped=grouped,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
