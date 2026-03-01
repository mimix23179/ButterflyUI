from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["ChatThread"]

class ChatThread(Component):
    """
    Scrollable thread of chat messages with optional input and grouping.

    The runtime renders a vertical list of chat messages. ``messages``
    provides an initial list of message specs. ``spacing`` controls gap
    between messages. ``reverse`` inverts scroll direction (latest at bottom).
    ``scrollable`` enables/disables the scroll container. ``group_messages``
    clusters consecutive messages from the same author.
    ``show_timestamps`` toggles timestamp display. ``auto_scroll`` keeps the
    view scrolled to the newest message. ``input_placeholder`` sets the
    placeholder of an attached composer.

    ```python
    import butterflyui as bui

    bui.ChatThread(
        messages=[],
        auto_scroll=True,
        show_timestamps=True,
        events=["send", "select"],
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
            Placeholder text for an attached message composer.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "chat_thread"

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
        merged = merge_props(
            props,
            messages=messages,
            spacing=spacing,
            reverse=reverse,
            scrollable=scrollable,
            group_messages=group_messages,
            show_timestamps=show_timestamps,
            auto_scroll=auto_scroll,
            input_placeholder=input_placeholder,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_messages(self, session: Any, messages: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_messages", {"messages": messages})

    def append_message(self, session: Any, message: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "append_message", {"message": dict(message)})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
