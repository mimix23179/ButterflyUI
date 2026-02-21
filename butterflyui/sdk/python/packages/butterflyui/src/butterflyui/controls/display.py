from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ._shared import Component, merge_props

__all__ = [
    "Text",
    "Icon",
    "Image",
    "Divider",
    "MarkdownView",
    "CodeView",
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



