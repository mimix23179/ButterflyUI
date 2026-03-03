from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Bubble"]


class Bubble(Component):
    """
    Unified conversation surface for message, thread, and composer UX.

    ``Bubble`` consolidates legacy controls into one API:
    ``chat``, ``chat_thread``, ``chat_message``, ``chat_bubble``,
    ``message_bubble``, ``message_composer``, and ``prompt_composer``.

    Use ``variant`` to indicate intent:
    - ``"message"`` for one message card
    - ``"thread"`` / ``"chat"`` for message collections
    - ``"composer"`` for input composition surfaces

    ```python
    import butterflyui as bui

    convo = bui.Bubble(
        variant="thread",
        messages=[
            {"role": "user", "text": "Status update?"},
            {"role": "assistant", "text": "Build completed."},
        ],
        show_input=True,
        input_placeholder="Type a reply...",
        events=["select", "send"],
    )
    ```

    Args:
        variant:
            Rendering mode hint (``"message"``, ``"thread"``, ``"chat"``,
            ``"composer"``).
        text:
            Main message text for message mode.
        title:
            Optional headline text.
        subtitle:
            Optional supporting text.
        author:
            Message author label.
        timestamp:
            Message timestamp label.
        status:
            Delivery/state label.
        edited:
            If ``True``, marks message as edited.
        pinned:
            If ``True``, marks message as pinned.
        divider_label:
            Optional divider caption rendered above the bubble.
        divider_color:
            Divider accent color.
        mention_label:
            Mention chip label.
        mention_color:
            Mention chip background color.
        mention_text_color:
            Mention chip text color.
        mention_clickable:
            If ``True``, mention chip emits click events.
        quote_text:
            Quoted message text.
        quote_author:
            Quoted message author label.
        quote_timestamp:
            Quoted message timestamp label.
        quote_compact:
            If ``True``, render quote in compact style.
        reactions:
            Reaction descriptors for message mode.
        actions:
            Inline action descriptors.
        messages:
            Message descriptors for thread/chat mode.
        items:
            Alias for ``messages``.
        spacing:
            Vertical spacing between thread messages.
        reverse:
            If ``True``, reverse thread order.
        scrollable:
            If ``False``, thread rendering is non-scrollable.
        group_messages:
            If ``True``, adjacent messages can be grouped.
        show_timestamps:
            If ``True``, render message timestamps in thread mode.
        show_input:
            If ``True``, show integrated composer in thread/chat mode.
        input_placeholder:
            Placeholder for integrated composer input.
        send_label:
            Send button label for composer mode.
        value:
            Composer input value.
        emit_on_change:
            If ``True``, emits change events while typing.
        clear_on_send:
            If ``True``, clears composer value after submit.
        min_lines:
            Minimum visible lines for composer input.
        max_lines:
            Maximum visible lines for composer input.
        show_attach:
            If ``True``, show attachment action in composer mode.
        role:
            Message role (for example ``"user"``, ``"assistant"``).
        name:
            Display name in message metadata.
        avatar:
            Avatar label or descriptor.
        grouped:
            Hint that message is grouped with a neighbor.
        clickable:
            If ``True``, message emits click events.
        align:
            Alignment hint for message mode.
        compact:
            Uses compact spacing.
        dense:
            Uses dense spacing.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """

    control_type = "bubble"

    def __init__(
        self,
        text: str | None = None,
        *,
        variant: str | None = None,
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
        messages: list[Any] | None = None,
        items: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        group_messages: bool | None = None,
        show_timestamps: bool | None = None,
        show_input: bool | None = None,
        input_placeholder: str | None = None,
        send_label: str | None = None,
        value: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        role: str | None = None,
        name: str | None = None,
        avatar: str | None = None,
        grouped: bool | None = None,
        clickable: bool | None = None,
        align: str | None = None,
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
                variant=variant,
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
                messages=messages if messages is not None else items,
                items=items if items is not None else messages,
                spacing=spacing,
                reverse=reverse,
                scrollable=scrollable,
                group_messages=group_messages,
                show_timestamps=show_timestamps,
                show_input=show_input,
                input_placeholder=input_placeholder,
                send_label=send_label,
                value=value,
                emit_on_change=emit_on_change,
                clear_on_send=clear_on_send,
                min_lines=min_lines,
                max_lines=max_lines,
                show_attach=show_attach,
                role=role,
                name=name,
                avatar=avatar,
                grouped=grouped,
                clickable=clickable,
                align=align,
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

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def submit(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "submit", {})

    def emit(
        self,
        session: Any,
        event: str = "click",
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )

