from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Text",
    "Icon",
    "EmojiIcon",
    "Image",
    "Divider",
    "MarkdownView",
    "CodeView",
    "CodeBlock",
    "RichTextEditor",
    "Chart",
    "BarChart",
    "Sparkline",
    "DiffView",
    "HtmlView",
    "EmptyState",
    "ErrorState",
]


class Text(Component):
    control_type = "text"

    def __init__(
        self,
        value: Any = "",
        *,
        text: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else str(value)
        merged = merge_props(props, text=resolved, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class Icon(Component):
    control_type = "icon"

    def __init__(
        self,
        icon: str | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, icon=icon, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class EmojiIcon(Component):
    control_type = "emoji_icon"

    def __init__(
        self,
        emoji: str | None = None,
        *,
        label: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            emoji=emoji,
            label=label,
            size=size,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_emoji(self, session: Any, emoji: str) -> dict[str, Any]:
        return self.invoke(session, "set_emoji", {"emoji": emoji})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Image(Component):
    control_type = "image"

    def __init__(
        self,
        src: str | None = None,
        *,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, src=src, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)


class Divider(Component):
    control_type = "divider"

    def __init__(
        self,
        *,
        vertical: bool | None = None,
        thickness: float | None = None,
        indent: float | None = None,
        end_indent: float | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            vertical=vertical,
            thickness=thickness,
            indent=indent,
            end_indent=end_indent,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class MarkdownView(Component):
    control_type = "markdown_view"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        selectable: bool | None = None,
        scrollable: bool | None = None,
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
            selectable=selectable,
            scrollable=scrollable,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class CodeView(Component):
    control_type = "code_view"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        language: str | None = None,
        selectable: bool | None = None,
        wrap: bool | None = None,
        show_line_numbers: bool | None = None,
        events: list[str] | None = None,
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
            language=language,
            selectable=selectable,
            wrap=wrap,
            show_line_numbers=show_line_numbers,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class CodeBlock(CodeView):
    control_type = "code_block"

    def __init__(
        self,
        value: str | None = None,
        *,
        text: str | None = None,
        language: str | None = None,
        selectable: bool | None = None,
        wrap: bool | None = None,
        show_line_numbers: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            text=text,
            language=language,
            selectable=selectable,
            wrap=wrap,
            show_line_numbers=show_line_numbers,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class RichTextEditor(Component):
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


class Chart(Component):
    control_type = "chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        chart_type: str | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values if values is not None else points,
            points=points if points is not None else values,
            chart_type=chart_type,
            fill=fill,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class BarChart(Component):
    control_type = "bar_chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        labels: list[str] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values if values is not None else points,
            points=points if points is not None else values,
            labels=labels,
            chart_type="bar",
            fill=fill,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_data(self, session: Any, values: list[Any], labels: list[str] | None = None) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values, "labels": labels})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Sparkline(Component):
    control_type = "sparkline"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values if values is not None else points,
            points=points if points is not None else values,
            fill=fill,
            color=color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class DiffView(Component):
    control_type = "diff_view"

    def __init__(
        self,
        *,
        before: str | None = None,
        after: str | None = None,
        split: bool | None = None,
        show_line_numbers: bool | None = None,
        wrap: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            before=before,
            after=after,
            split=split,
            show_line_numbers=show_line_numbers,
            wrap=wrap,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class HtmlView(Component):
    control_type = "html_view"

    def __init__(
        self,
        value: str | None = None,
        *,
        html: str | None = None,
        text: str | None = None,
        base_url: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = html if html is not None else (text if text is not None else value)
        merged = merge_props(
            props,
            html=resolved,
            value=resolved,
            text=resolved,
            base_url=base_url,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class EmptyState(Component):
    control_type = "empty_state"

    def __init__(
        self,
        *,
        title: str | None = None,
        message: str | None = None,
        action_label: str | None = None,
        icon: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            action_label=action_label,
            icon=icon,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class ErrorState(Component):
    control_type = "error_state"

    def __init__(
        self,
        *,
        title: str | None = None,
        message: str | None = None,
        detail: str | None = None,
        action_label: str | None = None,
        icon: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            detail=detail,
            action_label=action_label,
            icon=icon,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)



