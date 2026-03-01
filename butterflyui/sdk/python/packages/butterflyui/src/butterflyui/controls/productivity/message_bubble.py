from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .chat_message import ChatMessage

__all__ = ["MessageBubble"]

class MessageBubble(ChatMessage):
    """
    Compact bubble-style message row with role-based alignment.

    A focused variant of ``ChatMessage`` exposing ``text``, ``role``,
    ``name``, ``clickable``, and ``events``. Used for simpler chat UIs
    where timestamp, avatar, and grouping controls are not required.

    ```python
    import butterflyui as bui

    bui.MessageBubble(
        text="How can I help?",
        role="assistant",
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
        clickable:
            When ``True`` the bubble emits tap events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "message_bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
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
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
