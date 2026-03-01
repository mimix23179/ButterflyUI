from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .rich_text_editor import RichTextEditor

__all__ = ["RichText"]

class RichText(RichTextEditor):
    """Alias for ``RichTextEditor`` with a distinct control type.

    Inherits the full rich text editing surface — toolbar, bold/italic
    wrap helpers, debounced change events — and registers as
    ``"rich_text"`` in the runtime.  Use this when the semantic intent
    is a rich-text field rather than a standalone editor widget.

    Example::

        import butterflyui as bui

        editor = bui.RichText(
            value="Draft notes here...",
            show_toolbar=True,
            placeholder="Type something",
        )

    Args:
        value: 
            Initial rich-text content string.
        text: 
            Alias for ``value``.
        placeholder: 
            Hint text shown when the field is empty.
        read_only: 
            If ``True`` editing is disabled.
        show_toolbar: 
            If ``True`` (default) the formatting toolbar (bold, italic, underline, lists) is shown above the field.
        emit_on_change: 
            If ``True`` (default) a ``"change"`` event is emitted as content changes.
        debounce_ms: 
            Debounce interval in milliseconds for change events (default ``200``, clamped 0\u20132000).
        min_lines: 
            Minimum visible line count.
        max_lines: 
            Maximum visible line count.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "rich_text"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        placeholder: str | None = None,
        read_only: bool | None = None,
        show_toolbar: bool | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        min_lines: int | None = None,
        max_lines: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            text=text,
            placeholder=placeholder,
            read_only=read_only,
            show_toolbar=show_toolbar,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            min_lines=min_lines,
            max_lines=max_lines,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )
