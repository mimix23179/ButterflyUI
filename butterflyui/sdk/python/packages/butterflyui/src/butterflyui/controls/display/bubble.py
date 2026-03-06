from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
from ..title_control import TitleControl
from ..subtitle_control import SubtitleControl
from ..leading_control import LeadingControl
from ..trailing_control import TrailingControl
from ..items_control import ItemsControl
__all__ = ["Bubble"]

@butterfly_control('bubble', positional_fields=('text',))
class Bubble(LayoutControl, SingleChildControl, TitleControl, SubtitleControl, LeadingControl, TrailingControl, ItemsControl):
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

    Bubble supports the same universal style/modifier/motion/effects contract
    as other core controls, including slot styling (``label``, ``leading``,
    ``trailing``, ``overlay``) and state modifier lists.

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
    """

    scrollable: bool | None = None
    """
    Controls whether overflowing content is wrapped in a scrollable host instead of being laid out at its full intrinsic size.
    """

    role: str | None = None
    """
    Semantic author role for message rows (for example ``"user"``,
    ``"assistant"``, ``"system"``).
    """

    compact: bool | None = None
    """
    Enables a more compact visual density with reduced padding, gaps, or surface size.
    """

    dense: bool | None = None
    """
    Enables a denser layout with reduced gaps, padding, or row height.
    """

    align: str | None = None
    """
    Message alignment hint: ``"left"``, ``"right"``, or ``"auto"``.
    """

    grouping: str | None = None
    """
    Grouping strategy for adjacent messages (for example ``"auto"``).
    """

    group_messages: bool | None = None
    """
    Legacy grouping toggle for thread mode.
    """

    grouped: bool | None = None
    """
    Hint that this specific message belongs to a visual group.
    """

    selectable: bool | None = None
    """
    Enables text selection for message/composer text.
    """

    clickable: bool | None = None
    """
    Emits click/tap events from bubble body when enabled.
    """

    sender_name: str | None = None
    """
    Sender/author name in message header.
    """

    author: str | None = None
    """
    Legacy alias for ``sender_name``.
    """

    avatar: Any | None = None
    """
    Sender avatar descriptor (URL, asset path, initials, or map).
    """

    role_badge: str | None = None
    """
    Optional badge shown next to sender metadata.
    """

    text: str | None = None
    """
    Message body text (or composer initial value alias).
    """

    markdown: str | None = None
    """
    Markdown body source for message content.
    """

    timestamp: str | None = None
    """
    Timestamp string rendered with the message or item metadata.
    """

    edited: bool | None = None
    """
    Controls whether edited is enabled for this control.
    """

    delivered: bool | None = None
    """
    Controls whether delivered is enabled for this control.
    """

    read: bool | None = None
    """
    Reflects whether the message or item has been marked as read.
    """

    status: str | None = None
    """
    Status/meta label shown in message header.
    """

    error_notice: str | None = None
    """
    Error or failure notice shown inside the message.
    """

    notice: str | None = None
    """
    Informational notice shown inside the message.
    """

    attachments: list[Any] | None = None
    """
    Attachment descriptors for message mode.
    """

    reactions: list[Any] | None = None
    """
    Reaction descriptors (emoji/count/selected payloads).
    """

    actions: list[Any] | None = None
    """
    Inline action descriptors (reply/edit/delete/custom).
    """

    quote_text: str | None = None
    """
    Quoted text snippet rendered inside the message preview.
    """

    quote_author: str | None = None
    """
    Author label rendered for the quoted message or referenced content.
    """

    quote_timestamp: str | None = None
    """
    Timestamp label rendered for the quoted message or referenced content.
    """

    quote_compact: bool | None = None
    """
    Controls whether the quoted content is rendered in its compact visual variant.
    """

    mention_label: str | None = None
    """
    Label text rendered for mention.
    """

    mention_color: Any | None = None
    """
    Color value applied to mention when the control renders that visual element.
    """

    mention_text_color: Any | None = None
    """
    Color value applied to mention text.
    """

    mention_clickable: bool | None = None
    """
    Emits ``mention_click`` event when mention chip is tapped.
    """

    divider_label: str | None = None
    """
    Optional label text rendered inside or alongside the divider.
    """

    divider_color: Any | None = None
    """
    Color used when rendering the divider line or separator surface.
    """

    messages: list[Any] | None = None
    """
    Message list for thread/chat variant.
    """

    pinned_messages: list[Any] | None = None
    """
    Pinned message descriptors rendered above timeline.
    """

    spacing: float | None = None
    """
    Vertical spacing between thread rows.
    """

    reverse: bool | None = None
    """
    Controls whether the control renders its items in reverse order.
    """

    autoscroll: str | None = None
    """
    Thread scroll mode: ``"follow_latest"`` or ``"manual"``.
    """

    follow_latest: bool | None = None
    """
    Boolean alias for autoscroll follow mode.
    """

    unread_divider_label: str | None = None
    """
    Label for unread boundary divider.
    """

    unread_after_id: str | None = None
    """
    Inserts unread divider after this message id.
    """

    unread_index: int | None = None
    """
    Inserts unread divider after this index.
    """

    date_separators: list[Any] | None = None
    """
    Optional date-separator descriptors for thread rendering.
    """

    empty_state: Any | None = None
    """
    Empty-thread text or descriptor shown when no messages exist.
    """

    typing_indicator: Any | None = None
    """
    Typing indicator descriptor/text.
    """

    show_timestamps: bool | None = None
    """
    Thread-level timestamp visibility hint.
    """

    show_input: bool | None = None
    """
    Shows integrated composer when variant is thread/chat.
    """

    input_placeholder: str | None = None
    """
    Placeholder text for integrated composer.
    """

    send_label: str | None = None
    """
    Label text rendered for the send action associated with the control.
    """

    send_on_enter: bool | None = None
    """
    Sends on Enter (Shift+Enter inserts newline).
    """

    value: str | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    placeholder: str | None = None
    """
    Placeholder text shown when the control has no current value.
    """

    min_lines: int | None = None
    """
    Minimum visible lines for composer input.
    """

    max_lines: int | None = None
    """
    Maximum visible lines for composer input.
    """

    auto_expand: bool | None = None
    """
    If ``True``, composer grows between min/max lines.
    """

    show_attach: bool | None = None
    """
    Controls whether the control should display its attachment action or attachment slot.
    """

    draft_key: str | None = None
    """
    Persistent key used to store and restore draft state for this control.
    """

    char_limit: int | None = None
    """
    Maximum number of characters accepted or displayed by the control.
    """

    show_counter: bool | None = None
    """
    Shows character counter when char limit is active.
    """

    cooldown_ms: int | None = None
    """
    Optional send cooldown in milliseconds.
    """

    read_only: bool | None = None
    """
    Controls whether the control remains visible but blocks direct user editing.
    """

    emit_on_change: bool | None = None
    """
    Emits change events while typing.
    """

    clear_on_send: bool | None = None
    """
    Controls whether the current input value is cleared automatically after a send action completes.
    """

    line_color: Any | None = None
    """
    Line color value forwarded to the `bubble` runtime control.
    """

    use_flutter_chat_ui: Any | None = None
    """
    Use flutter chat ui value forwarded to the `bubble` runtime control.
    """

    user_id: Any | None = None
    """
    User id value forwarded to the `bubble` runtime control.
    """

    multiline: Any | None = None
    """
    Multiline value forwarded to the `bubble` runtime control.
    """

    submit_label: Any | None = None
    """
    Submit label value forwarded to the `bubble` runtime control.
    """

    show_send: Any | None = None
    """
    Show send value forwarded to the `bubble` runtime control.
    """

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
