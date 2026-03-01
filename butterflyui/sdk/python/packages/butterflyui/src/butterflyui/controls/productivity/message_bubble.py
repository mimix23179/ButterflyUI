from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .chat_message import ChatMessage

__all__ = ["MessageBubble"]

class MessageBubble(ChatMessage):
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
