from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from ...core.schema import ButterflyUIContractError, ensure_valid_props
from .._shared import Component, merge_props

__all__ = ["MessageComposer"]

class MessageComposer(Component):
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
