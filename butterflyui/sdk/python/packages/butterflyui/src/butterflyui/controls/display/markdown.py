from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .markdown_view import MarkdownView

__all__ = ["Markdown"]

class Markdown(MarkdownView):
    """Short-hand Markdown renderer that delegates to ``MarkdownView``.

    Convenience alias for ``MarkdownView`` with the same parameter
    set.  Renders a Markdown string using ``flutter_markdown_plus``
    with support for selectable text and optional scrolling.

    Use ``get_value`` / ``set_value`` to read or replace the Markdown
    content at runtime.

    Example::

        import butterflyui as bui

        md = bui.Markdown(value="# Hello\nSome **bold** text.")

    Args:
        value: 
            Markdown source string.
        text: 
            Alias for ``value``.
        selectable: 
            If ``True`` the rendered text is selectable.
        scrollable: 
            If ``True`` (default) the content scrolls when it overflows.
    """
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
