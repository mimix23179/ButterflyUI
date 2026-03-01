from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RichTextEditor"]

class RichTextEditor(Component):
    """Multi-line rich text editor with a formatting toolbar.

    Renders a ``TextField`` with an optional toolbar offering Bold,
    Italic, Underline, bullet-list, and numbered-list formatting
    helpers.  Text changes are debounced and emitted as ``"change"``
    events.  The editor supports ``read_only`` mode and can be
    programmatically controlled via ``get_value``, ``set_value``,
    ``focus``, and ``blur``.

    Example::

        import butterflyui as bui

        editor = bui.RichTextEditor(
            value="Hello **world**",
            placeholder="Start writing...",
            show_toolbar=True,
            min_lines=6,
        )

    Args:
        value: 
            Initial text content.
        text: 
            Alias for ``value``.
        placeholder: 
            Hint text shown when the field is empty.
        read_only: 
            If ``True`` the text cannot be edited.
        show_toolbar: 
            If ``True`` (default) the formatting toolbar is displayed above the text field.
        emit_on_change: 
            If ``True`` (default) ``"change"`` events are emitted as the user types.
        debounce_ms: 
            Debounce interval in milliseconds for change events (default ``200``, clamped 0\u20132000).
        min_lines: 
            Minimum number of visible text lines (default 8).
        max_lines: 
            Maximum number of visible text lines.
    """
    control_type = "rich_text_editor"

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
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else value
        merged = merge_props(
            props,
            value=resolved,
            text=resolved,
            placeholder=placeholder,
            read_only=read_only,
            show_toolbar=show_toolbar,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            min_lines=min_lines,
            max_lines=max_lines,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})
