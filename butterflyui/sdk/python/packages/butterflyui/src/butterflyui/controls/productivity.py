from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "CodeEditor",
    "Terminal",
    "ChatThread",
    "ChatMessage",
    "MessageComposer",
    "PromptComposer",
    "Form",
    "FormField",
    "ValidationSummary",
]


class CodeEditor(Component):
    control_type = "code_editor"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        code: str | None = None,
        language: str | None = None,
        read_only: bool | None = None,
        word_wrap: bool | None = None,
        line_numbers: bool | None = None,
        show_gutter: bool | None = None,
        show_minimap: bool | None = None,
        glyph_margin: bool | None = None,
        engine: str | None = None,
        webview_engine: str | None = None,
        document_uri: str | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = code if code is not None else (text if text is not None else value)
        merged = merge_props(
            props,
            value=resolved,
            text=resolved,
            code=resolved,
            language=language,
            read_only=read_only,
            word_wrap=word_wrap,
            line_numbers=line_numbers,
            show_gutter=show_gutter,
            show_minimap=show_minimap,
            glyph_margin=glyph_margin,
            engine=engine,
            webview_engine=webview_engine,
            document_uri=document_uri,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
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

    def select_all(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "select_all", {})

    def insert_text(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "insert_text", {"value": value})

    def format_document(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "format_document", {})

    def reveal_line(self, session: Any, line: int) -> dict[str, Any]:
        return self.invoke(session, "reveal_line", {"line": line})

    def set_markers(self, session: Any, markers: list[dict[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_markers", {"markers": markers})


class Terminal(Component):
    control_type = "terminal"

    def __init__(
        self,
        *,
        lines: list[Any] | None = None,
        events: list[Any] | None = None,
        output: str | None = None,
        raw_text: str | None = None,
        show_input: bool | None = None,
        read_only: bool | None = None,
        clear_on_submit: bool | None = None,
        strip_ansi: bool | None = None,
        auto_scroll: bool | None = None,
        wrap_lines: bool | None = None,
        max_lines: int | None = None,
        engine: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            lines=lines,
            events=events,
            output=output,
            raw_text=raw_text,
            show_input=show_input,
            read_only=read_only,
            clear_on_submit=clear_on_submit,
            strip_ansi=strip_ansi,
            auto_scroll=auto_scroll,
            wrap_lines=wrap_lines,
            max_lines=max_lines,
            engine=engine,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def write(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "write", {"value": value})

    def append_lines(self, session: Any, lines: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "append_lines", {"lines": lines})

    def focus(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "focus", {})

    def blur(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "blur", {})

    def set_input(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_input", {"value": value})

    def set_read_only(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_read_only", {"value": value})

    def get_buffer(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_buffer", {})


class ChatThread(Component):
    control_type = "chat_thread"

    def __init__(
        self,
        *children: Any,
        messages: list[Any] | None = None,
        spacing: float | None = None,
        reverse: bool | None = None,
        scrollable: bool | None = None,
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
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class ChatMessage(Component):
    control_type = "chat_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        role: str | None = None,
        name: str | None = None,
        clickable: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            value=text,
            role=role,
            name=name,
            clickable=clickable,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


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


class PromptComposer(MessageComposer):
    control_type = "prompt_composer"


class Form(Component):
    control_type = "form"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        description: str | None = None,
        spacing: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            description=description,
            spacing=spacing,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)


class FormField(Component):
    control_type = "form_field"

    def __init__(
        self,
        child: Any | None = None,
        *,
        label: str | None = None,
        description: str | None = None,
        required: bool | None = None,
        helper_text: str | None = None,
        error_text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            description=description,
            required=required,
            helper_text=helper_text,
            error_text=error_text,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)


class ValidationSummary(Component):
    control_type = "validation_summary"

    def __init__(
        self,
        *,
        title: str | None = None,
        errors: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, title=title, errors=errors, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)

