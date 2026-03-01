from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .chat_thread import ChatThread

__all__ = ["Chat"]

class Chat(ChatThread):
    control_type = "chat"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        group_messages: bool | None = None,
        show_timestamps: bool | None = None,
        auto_scroll: bool | None = None,
        input_placeholder: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            group_messages=group_messages,
            show_timestamps=show_timestamps,
            auto_scroll=auto_scroll,
            input_placeholder=input_placeholder,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
