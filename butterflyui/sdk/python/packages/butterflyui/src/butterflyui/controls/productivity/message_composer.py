from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["MessageComposer"]

class MessageComposer(Component):
    """
    Multi-line message input with send button and optional attachment support.

    The runtime renders a text-entry area with a send action. ``value``
    seeds the initial text. ``placeholder`` sets the hint text.
    ``send_label`` customises the send button. ``emit_on_change`` fires
    change events on every keystroke. ``clear_on_send`` empties the input
    after sending. ``min_lines``/``max_lines`` control the textarea height.
    ``show_attach`` reveals an attachment button.

    ```python
    import butterflyui as bui

    bui.MessageComposer(
        placeholder="Type a message…",
        clear_on_send=True,
        show_attach=True,
    )
    ```

    Args:
        value:
            Initial text content of the composer.
        placeholder:
            Hint text shown when the composer is empty.
        send_label:
            Label or icon identifier for the send button.
        emit_on_change:
            When ``True`` a change event is emitted on every keystroke.
        clear_on_send:
            When ``True`` the input is cleared after the send action.
        min_lines:
            Minimum number of visible text lines.
        max_lines:
            Maximum number of visible text lines before scrolling.
        show_attach:
            When ``True`` an attachment button is shown.
    """

    control_type = "message_composer"

    def __init__(
        self,
        value: str | None = None,
        *,
        placeholder: str | None = None,
        send_label: str | None = None,
        emit_on_change: bool | None = None,
        clear_on_send: bool | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        show_attach: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            placeholder=placeholder,
            send_label=send_label,
            emit_on_change=emit_on_change,
            clear_on_send=clear_on_send,
            min_lines=min_lines,
            max_lines=max_lines,
            show_attach=show_attach,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
