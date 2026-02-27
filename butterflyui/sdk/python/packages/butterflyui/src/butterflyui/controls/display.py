from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Text",
    "Icon",
    "EmojiIcon",
    "Avatar",
    "Image",
    "Divider",
    "MarkdownView",
    "CodeView",
    "CodeBlock",
    "RichTextEditor",
    "RichText",
    "Chart",
    "BarChart",
    "Sparkline",
    "SparkPlot",
    "BarPlot",
    "DiffView",
    "HtmlView",
    "Html",
    "Markdown",
    "LineChart",
    "LinePlot",
    "ArtifactCard",
    "ResultCard",
    "AttachmentTile",
    "Audio",
    "Canvas",
    "EmptyState",
    "ErrorState",
    "Glyph",
    "GlyphButton",
    "MentionPill",
    "MessageDivider",
    "MessageMeta",
    "ReactionBar",
    "QuotedMessage",
    "RatingDisplay",
    "StatusMark",
    "Persona",
    "PiePlot",
    "TypingIndicator",
    "VectorView",
    "Video",
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
        icon: str | int | None = None,
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
        fallback: str | None = None,
        variant: str | None = None,
        background: Any | None = None,
        radius: float | None = None,
        padding: Any | None = None,
        enabled: bool | None = None,
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
            fallback=fallback,
            variant=variant,
            background=background,
            radius=radius,
            padding=padding,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_emoji(self, session: Any, emoji: str) -> dict[str, Any]:
        return self.invoke(session, "set_emoji", {"emoji": emoji})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Avatar(Component):
    control_type = "avatar"

    def __init__(
        self,
        src: str | None = None,
        *,
        image: str | None = None,
        name: str | None = None,
        initials: str | None = None,
        icon: str | None = None,
        size: float | None = None,
        radius: float | None = None,
        color: Any | None = None,
        bgcolor: Any | None = None,
        status: str | None = None,
        badge: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src if src is not None else image,
            image=image if image is not None else src,
            name=name,
            initials=initials,
            icon=icon,
            size=size,
            radius=radius,
            color=color,
            bgcolor=bgcolor,
            status=status,
            badge=badge,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_src(self, session: Any, src: str) -> dict[str, Any]:
        return self.invoke(session, "set_src", {"src": src})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Glyph(Icon):
    control_type = "glyph"

    def __init__(
        self,
        glyph: str | int | None = None,
        *,
        icon: str | int | None = None,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            icon=icon if icon is not None else glyph,
            props=merge_props(props, tooltip=tooltip, size=size, color=color),
            style=style,
            strict=strict,
            **kwargs,
        )


class GlyphButton(Component):
    control_type = "glyph_button"

    def __init__(
        self,
        glyph: str | int | None = None,
        *,
        icon: str | int | None = None,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            glyph=glyph if glyph is not None else icon,
            icon=icon if icon is not None else glyph,
            tooltip=tooltip,
            size=size,
            color=color,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class MentionPill(Component):
    control_type = "mention_pill"

    def __init__(
        self,
        label: str | None = None,
        *,
        color: Any | None = None,
        text_color: Any | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            color=color,
            text_color=text_color,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class MessageDivider(Component):
    control_type = "message_divider"

    def __init__(
        self,
        label: str | None = None,
        *,
        padding: Any | None = None,
        color: Any | None = None,
        text_color: Any | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            padding=padding,
            color=color,
            text_color=text_color,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class MessageMeta(Component):
    control_type = "message_meta"

    def __init__(
        self,
        *,
        timestamp: str | None = None,
        status: str | None = None,
        edited: bool | None = None,
        pinned: bool | None = None,
        align: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            timestamp=timestamp,
            status=status,
            edited=edited,
            pinned=pinned,
            align=align,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ReactionBar(Component):
    control_type = "reaction_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected: list[str] | None = None,
        max_visible: int | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected=selected,
            max_visible=max_visible,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class QuotedMessage(Component):
    control_type = "quoted_message"

    def __init__(
        self,
        text: str | None = None,
        *,
        author: str | None = None,
        timestamp: str | None = None,
        compact: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            author=author,
            timestamp=timestamp,
            compact=compact,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class RatingDisplay(Component):
    control_type = "rating_display"

    def __init__(
        self,
        *,
        value: float | None = None,
        max: int | None = None,
        allow_half: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            max=max,
            allow_half=allow_half,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)


class Persona(Component):
    control_type = "persona"

    def __init__(
        self,
        name: str | None = None,
        *,
        subtitle: str | None = None,
        avatar: str | None = None,
        status: str | None = None,
        initials: str | None = None,
        layout: str | None = None,
        show_avatar: bool | None = None,
        avatar_color: Any | None = None,
        leading: Any | None = None,
        title_widget: Any | None = None,
        subtitle_widget: Any | None = None,
        trailing: Any | None = None,
        content: Any | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            name=name,
            subtitle=subtitle,
            avatar=avatar,
            status=status,
            initials=initials,
            layout=layout,
            show_avatar=show_avatar,
            avatar_color=avatar_color,
            leading=leading,
            title_widget=title_widget,
            subtitle_widget=subtitle_widget,
            trailing=trailing,
            content=content,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, 'set_props', props)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, 'get_state', {})

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class StatusMark(Component):
    control_type = "status_mark"

    def __init__(
        self,
        *,
        label: str | None = None,
        status: str | None = None,
        value: str | None = None,
        icon: str | None = None,
        dense: bool | None = None,
        align: str | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            status=status,
            value=value,
            icon=icon,
            dense=dense,
            align=align,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_status(self, session: Any, status: str) -> dict[str, Any]:
        return self.invoke(session, "set_status", {"status": status})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class PiePlot(Component):
    control_type = "pie_plot"

    def __init__(
        self,
        *,
        values: list[float] | None = None,
        labels: list[str] | None = None,
        colors: list[Any] | None = None,
        donut: bool | None = None,
        hole: float | None = None,
        start_angle: float | None = None,
        clockwise: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            values=values,
            labels=labels,
            colors=colors,
            donut=donut,
            hole=hole,
            start_angle=start_angle,
            clockwise=clockwise,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

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


class Markdown(MarkdownView):
    control_type = "markdown"

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
        super().__init__(
            value=value,
            text=text,
            selectable=selectable,
            scrollable=scrollable,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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


class RichText(RichTextEditor):
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


class LineChart(Chart):
    control_type = "line_chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            values=values,
            points=points,
            chart_type="line",
            fill=fill,
            color=color,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class LinePlot(LineChart):
    control_type = "line_plot"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            values=values,
            points=points,
            fill=fill,
            color=color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class BarChart(Component):
    control_type = "bar_chart"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        labels: list[str] | None = None,
        datasets: list[Mapping[str, Any]] | None = None,
        grouped: bool | None = None,
        stacked: bool | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        animate: bool | None = None,
        show_tooltip: bool | None = None,
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
            datasets=[dict(item) for item in (datasets or [])],
            grouped=grouped,
            stacked=stacked,
            chart_type="bar",
            fill=fill,
            color=color,
            animate=animate,
            show_tooltip=show_tooltip,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_data(
        self,
        session: Any,
        values: list[Any],
        labels: list[str] | None = None,
        datasets: list[Mapping[str, Any]] | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {"values": values, "labels": labels}
        if datasets is not None:
            payload["datasets"] = [dict(item) for item in datasets]
        return self.invoke(session, "set_data", payload)

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

    def set_data(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_data", {"values": values})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class SparkPlot(Sparkline):
    control_type = "spark_plot"

    def __init__(
        self,
        *,
        values: list[Any] | None = None,
        points: list[Any] | None = None,
        fill: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            values=values,
            points=points,
            fill=fill,
            color=color,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )


class BarPlot(BarChart):
    control_type = "bar_plot"

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
        super().__init__(
            values=values,
            points=points,
            labels=labels,
            fill=fill,
            color=color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


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
        html_file: str | None = None,
        base_url: str | None = None,
        events: list[str] | None = None,
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
            html_file=html_file,
            base_url=base_url,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def load_file(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "load_file", {"path": path})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Html(HtmlView):
    control_type = "html"

    def __init__(
        self,
        value: str | None = None,
        *,
        html: str | None = None,
        text: str | None = None,
        html_file: str | None = None,
        base_url: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            html=html,
            text=text,
            html_file=html_file,
            base_url=base_url,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class ArtifactCard(Component):
    control_type = "artifact_card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        message: str | None = None,
        variant: str | None = None,
        label: str | None = None,
        action_label: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            message=message,
            variant=variant,
            label=label,
            action_label=action_label,
            clickable=clickable,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_content(self, session: Any, *, title: str | None = None, message: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if title is not None:
            payload["title"] = title
        if message is not None:
            payload["message"] = message
        return self.invoke(session, "set_content", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class ResultCard(ArtifactCard):
    control_type = "result_card"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        message: str | None = None,
        variant: str | None = None,
        label: str | None = None,
        action_label: str | None = None,
        clickable: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            title=title,
            message=message,
            variant=variant,
            label=label,
            action_label=action_label,
            clickable=clickable,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )


class AttachmentTile(Component):
    control_type = "attachment_tile"

    def __init__(
        self,
        *,
        label: str | None = None,
        subtitle: str | None = None,
        type: str | None = None,
        src: str | None = None,
        clickable: bool | None = None,
        show_remove: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            subtitle=subtitle,
            type=type,
            src=src,
            clickable=clickable,
            show_remove=show_remove,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_src(self, session: Any, src: str) -> dict[str, Any]:
        return self.invoke(session, "set_src", {"src": src})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Audio(Component):
    control_type = "audio"

    def __init__(
        self,
        *,
        src: str | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        volume: float | None = None,
        muted: bool | None = None,
        title: str | None = None,
        artist: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            autoplay=autoplay,
            loop=loop,
            volume=volume,
            muted=muted,
            title=title,
            artist=artist,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_position(self, session: Any, seconds: float) -> dict[str, Any]:
        return self.invoke(session, "set_position", {"seconds": float(seconds)})

    def set_volume(self, session: Any, volume: float) -> dict[str, Any]:
        return self.invoke(session, "set_volume", {"volume": float(volume)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Video(Component):
    control_type = "video"

    def __init__(
        self,
        *,
        src: str | None = None,
        poster: str | None = None,
        autoplay: bool | None = None,
        loop: bool | None = None,
        muted: bool | None = None,
        controls: bool | None = None,
        fit: str | None = None,
        volume: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            poster=poster,
            autoplay=autoplay,
            loop=loop,
            muted=muted,
            controls=controls,
            fit=fit,
            volume=volume,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def play(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "play", {})

    def pause(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "pause", {})

    def set_position(self, session: Any, seconds: float) -> dict[str, Any]:
        return self.invoke(session, "set_position", {"seconds": float(seconds)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class TypingIndicator(Component):
    control_type = "typing_indicator"

    def __init__(
        self,
        *,
        text: str | None = None,
        count: int | None = None,
        speed_ms: int | None = None,
        dot_size: float | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            text=text,
            count=count,
            speed_ms=speed_ms,
            dot_size=dot_size,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class VectorView(Component):
    control_type = "vector_view"

    def __init__(
        self,
        *,
        src: str | None = None,
        data: str | None = None,
        fit: str | None = None,
        color: Any | None = None,
        tint: Any | None = None,
        opacity: float | None = None,
        width: float | None = None,
        height: float | None = None,
        alignment: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            data=data,
            fit=fit,
            color=color,
            tint=tint,
            opacity=opacity,
            width=width,
            height=height,
            alignment=alignment,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


class Canvas(Component):
    control_type = "canvas"

    def __init__(
        self,
        *,
        strokes: list[Mapping[str, Any]] | None = None,
        shapes: list[Mapping[str, Any]] | None = None,
        background: Any | None = None,
        grid: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            strokes=strokes,
            shapes=shapes,
            background=background,
            grid=grid,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_shapes(self, session: Any, shapes: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_shapes", {"shapes": [dict(shape) for shape in shapes]})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})


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



