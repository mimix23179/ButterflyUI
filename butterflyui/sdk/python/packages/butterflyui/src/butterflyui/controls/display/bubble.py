from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Bubble"]


class Bubble(Component):
    """
    Unified conversation surface with ``message``, ``thread/chat``, and ``composer`` variants.

    ``Bubble`` is the consolidated control for conversational UX in ButterflyUI.
    It replaces the older split controls such as ``chat_bubble``, ``chat_thread``,
    ``message_bubble``, ``message_composer``, and ``prompt_composer`` while keeping
    a single prop model and invoke API.

    The control is intentionally variant-scoped:
    - ``variant="message"``: one message tile with metadata, attachments, actions, reactions.
    - ``variant="thread"`` / ``variant="chat"``: message list ergonomics, separators, jump APIs.
    - ``variant="composer"``: expanding input row with attach/send behaviors.

    Example:
        ```python
        import butterflyui as bui

        thread = bui.Bubble(
            variant="thread",
            messages=[
                {"id": "m1", "sender_name": "Ari", "text": "Morning update?"},
                {"id": "m2", "role": "assistant", "text": "Build succeeded."},
            ],
            group_messages=True,
            unread_divider_label="Unread",
            show_input=True,
            input_placeholder="Write a reply...",
            events=["reach_top", "scroll_state_changed", "submit", "attach"],
        )
        ```

    Args:
        variant:
            Bubble role. Supported runtime values are ``"message"``, ``"thread"``,
            ``"chat"``, and ``"composer"``.
        role:
            Semantic author role for message rows (for example ``"user"``,
            ``"assistant"``, ``"system"``).
        tone:
            Semantic tone (``"neutral"``, ``"info"``, ``"success"``, ``"warn"``,
            ``"danger"``). Used as a styling hint.
        density:
            Density hint (``"compact"``, ``"normal"``, ``"cozy"``).
        compact:
            Legacy density alias.
        dense:
            Legacy density alias.
        align:
            Message alignment hint: ``"left"``, ``"right"``, or ``"auto"``.
        max_width:
            Maximum width constraint for message cards/composer surface.
        grouping:
            Grouping strategy for adjacent messages (for example ``"auto"``).
        group_messages:
            Legacy grouping toggle for thread mode.
        grouped:
            Hint that this specific message belongs to a visual group.
        selectable:
            Enables text selection for message/composer text.
        clickable:
            Emits click/tap events from bubble body when enabled.

        sender_name:
            Sender/author name in message header.
        author:
            Legacy alias for ``sender_name``.
        avatar:
            Sender avatar descriptor (URL, asset path, initials, or map).
        role_badge:
            Optional badge shown next to sender metadata.
        title:
            Primary title/headline line.
        subtitle:
            Secondary line under title.
        text:
            Message body text (or composer initial value alias).
        markdown:
            Markdown body source for message content.
        child:
            Optional child control rendered inside the bubble body.
        timestamp:
            Message timestamp string.
        edited:
            Marks message as edited.
        delivered:
            Marks message as delivered.
        read:
            Marks message as read.
        status:
            Status/meta label shown in message header.
        error_notice:
            Error or failure notice shown inside the message.
        notice:
            Informational notice shown inside the message.

        attachments:
            Attachment descriptors for message mode.
        reactions:
            Reaction descriptors (emoji/count/selected payloads).
        actions:
            Inline action descriptors (reply/edit/delete/custom).

        quote_text:
            Quoted/referenced body text.
        quote_author:
            Quoted author label.
        quote_timestamp:
            Quoted timestamp label.
        quote_compact:
            Compacts quote block rendering.
        mention_label:
            Mention chip label.
        mention_color:
            Mention chip background.
        mention_text_color:
            Mention chip foreground.
        mention_clickable:
            Emits ``mention_click`` event when mention chip is tapped.
        divider_label:
            Label for a top divider row.
        divider_color:
            Divider color override.

        messages:
            Message list for thread/chat variant.
        items:
            Alias for ``messages``.
        pinned_messages:
            Pinned message descriptors rendered above timeline.
        spacing:
            Vertical spacing between thread rows.
        reverse:
            Reverses message list order.
        scrollable:
            Enables thread scrolling.
        autoscroll:
            Thread scroll mode: ``"follow_latest"`` or ``"manual"``.
        follow_latest:
            Boolean alias for autoscroll follow mode.
        unread_divider_label:
            Label for unread boundary divider.
        unread_after_id:
            Inserts unread divider after this message id.
        unread_index:
            Inserts unread divider after this index.
        date_separators:
            Optional date-separator descriptors for thread rendering.
        empty_state:
            Empty-thread text or descriptor shown when no messages exist.
        typing_indicator:
            Typing indicator descriptor/text.
        show_timestamps:
            Thread-level timestamp visibility hint.

        show_input:
            Shows integrated composer when variant is thread/chat.
        input_placeholder:
            Placeholder text for integrated composer.
        send_label:
            Send action label.
        send_on_enter:
            Sends on Enter (Shift+Enter inserts newline).
        value:
            Composer current value.
        placeholder:
            Composer placeholder alias.
        min_lines:
            Minimum visible lines for composer input.
        max_lines:
            Maximum visible lines for composer input.
        auto_expand:
            If ``True``, composer grows between min/max lines.
        leading:
            Leading composer slot descriptor.
        trailing:
            Trailing composer slot descriptor.
        show_attach:
            Shows attachment action.
        draft_key:
            Optional draft-persistence key.
        char_limit:
            Maximum composer characters.
        show_counter:
            Shows character counter when char limit is active.
        cooldown_ms:
            Optional send cooldown in milliseconds.
        disabled:
            Disables interaction.
        read_only:
            Locks composer edits.
        emit_on_change:
            Emits change events while typing.
        clear_on_send:
            Clears composer after submit.

        events:
            Event names emitted by runtime (examples: ``submit``, ``change``,
            ``attach``, ``reach_top``, ``scroll_state_changed``, ``action``,
            ``react``, ``message_click``).
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Local style map forwarded to the style resolver.
        strict:
            Enables strict schema validation when supported.
    """

    control_type = "bubble"

    def __init__(
        self,
        text: str | None = None,
        *children_args: Any,
        variant: str | None = None,
        role: str | None = None,
        tone: str | None = None,
        density: str | None = None,
        compact: bool | None = None,
        dense: bool | None = None,
        align: str | None = None,
        max_width: Any | None = None,
        grouping: str | None = None,
        group_messages: bool | None = None,
        grouped: bool | None = None,
        selectable: bool | None = None,
        clickable: bool | None = None,
        sender_name: str | None = None,
        author: str | None = None,
        avatar: Any | None = None,
        role_badge: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        markdown: str | None = None,
        timestamp: str | None = None,
        edited: bool | None = None,
        delivered: bool | None = None,
        read: bool | None = None,
        status: str | None = None,
        error_notice: str | None = None,
        notice: str | None = None,
        attachments: list[Any] | None = None,
        reactions: list[Any] | None = None,
        actions: list[Any] | None = None,
        quote_text: str | None = None,
        quote_author: str | None = None,
        quote_timestamp: str | None = None,
        quote_compact: bool | None = None,
        mention_label: str | None = None,
        mention_color: Any | None = None,
        mention_text_color: Any | None = None,
        mention_clickable: bool | None = None,
        divider_label: str | None = None,
        divider_color: Any | None = None,
        messages: list[Any] | None = None,
        items: list[Any] | None = None,
        pinned_messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
        autoscroll: str | None = None,
        follow_latest: bool | None = None,
        unread_divider_label: str | None = None,
        unread_after_id: str | None = None,
        unread_index: int | None = None,
        date_separators: list[Any] | None = None,
        empty_state: Any | None = None,
        typing_indicator: Any | None = None,
        show_timestamps: bool | None = None,
        show_input: bool | None = None,
        input_placeholder: str | None = None,
        send_label: str | None = None,
        send_on_enter: bool | None = None,
        value: str | None = None,
        placeholder: str | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        auto_expand: bool | None = None,
        leading: Any | None = None,
        trailing: Any | None = None,
        show_attach: bool | None = None,
        draft_key: str | None = None,
        char_limit: int | None = None,
        show_counter: bool | None = None,
        cooldown_ms: int | None = None,
        disabled: bool | None = None,
        read_only: bool | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        events: list[str] | None = None,
        child: Any | None = None,
        children: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children_args,
            child=child,
            children=children,
            props=merge_props(
                props,
                variant=variant,
                role=role,
                tone=tone,
                density=density,
                compact=compact,
                dense=dense,
                align=align,
                max_width=max_width,
                grouping=grouping,
                group_messages=group_messages,
                grouped=grouped,
                selectable=selectable,
                clickable=clickable,
                sender_name=sender_name if sender_name is not None else author,
                author=author if author is not None else sender_name,
                avatar=avatar,
                role_badge=role_badge,
                title=title,
                subtitle=subtitle,
                text=text,
                markdown=markdown,
                timestamp=timestamp,
                edited=edited,
                delivered=delivered,
                read=read,
                status=status,
                error_notice=error_notice,
                notice=notice,
                attachments=attachments,
                reactions=reactions,
                actions=actions,
                quote_text=quote_text,
                quote_author=quote_author,
                quote_timestamp=quote_timestamp,
                quote_compact=quote_compact,
                mention_label=mention_label,
                mention_color=mention_color,
                mention_text_color=mention_text_color,
                mention_clickable=mention_clickable,
                divider_label=divider_label,
                divider_color=divider_color,
                messages=messages if messages is not None else items,
                items=items if items is not None else messages,
                pinned_messages=pinned_messages,
                spacing=spacing,
                reverse=reverse,
                scrollable=scrollable,
                autoscroll=autoscroll,
                follow_latest=follow_latest,
                unread_divider_label=unread_divider_label,
                unread_after_id=unread_after_id,
                unread_index=unread_index,
                date_separators=date_separators,
                empty_state=empty_state,
                typing_indicator=typing_indicator,
                show_timestamps=show_timestamps,
                show_input=show_input,
                input_placeholder=input_placeholder if input_placeholder is not None else placeholder,
                send_label=send_label,
                send_on_enter=send_on_enter,
                value=value if value is not None else text,
                placeholder=placeholder if placeholder is not None else input_placeholder,
                min_lines=min_lines,
                max_lines=max_lines,
                auto_expand=auto_expand,
                leading=leading,
                trailing=trailing,
                show_attach=show_attach,
                draft_key=draft_key,
                char_limit=char_limit,
                show_counter=show_counter,
                cooldown_ms=cooldown_ms,
                disabled=disabled,
                read_only=read_only,
                emit_on_change=emit_on_change,
                clear_on_send=clear_on_send,
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

    def append_message(self, session: Any, message: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "append_message", {"message": dict(message)})

    def prepend_messages(self, session: Any, messages: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(
            session,
            "prepend_messages",
            {"messages": [dict(item) for item in messages]},
        )

    def jump_to_bottom(self, session: Any, *, animated: bool = True) -> dict[str, Any]:
        return self.invoke(session, "jump_to_bottom", {"animated": animated})

    def jump_to_message(
        self,
        session: Any,
        *,
        message_id: str | None = None,
        index: int | None = None,
        align: str | None = None,
        animated: bool = True,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "jump_to_message",
            merge_props(
                None,
                message_id=message_id,
                index=index,
                align=align,
                animated=animated,
            ),
        )

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
