from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props
from .chat_thread import ChatThread

__all__ = ["Chat"]

class Chat(ChatThread):
    """
    Full-featured chat view combining a message thread with a message composer.

    A specialization of ``ChatThread`` that bundles an integrated message
    composer. Inherits all ``ChatThread`` properties for message display,
    scrolling, and grouping.

    ```python
    import butterflyui as bui

    bui.Chat(
        messages=[],
        auto_scroll=True,
        input_placeholder="Type a message…",
        events=["send"],
    )
    ```

    Args:
        messages:
            Initial list of message spec mappings.
        spacing:
            Vertical gap in logical pixels between message items.
        reverse:
            When ``True`` new messages appear at the bottom of the list.
        scrollable:
            When ``False`` the thread does not scroll.
        group_messages:
            When ``True`` consecutive messages from the same author are
            grouped visually.
        show_timestamps:
            When ``True`` timestamps are shown beneath each message.
        auto_scroll:
            When ``True`` the view automatically scrolls to the latest
            message.
        input_placeholder:
            Placeholder text for the integrated message composer.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

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
