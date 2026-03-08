from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from ..base_control import butterfly_control
from ..layout_control import LayoutControl
from ..single_child_control import SingleChildControl

__all__ = ["MarkdownView"]


@butterfly_control(
    "markdown_view",
    field_aliases={"content": "child"},
    positional_fields=("value",),
)
class MarkdownView(LayoutControl, SingleChildControl):
    """
    Rendered Markdown content viewer.

    Displays a Markdown string using ButterflyUI's rich Markdown runtime.
    GitHub-flavored markdown, lists, numbered lists, tables, fenced code
    blocks, horizontal rules, inline emphasis, and custom HTML-backed tags
    such as underline can be rendered by the Flutter client. When
    ``render_mode="html"`` is selected, the runtime converts the markdown
    source to HTML and displays it through the existing HTML view pipeline.

    Use ``get_value`` to retrieve the current Markdown source and
    ``set_value`` to replace it at runtime.
    """

    scrollable: bool | None = None
    """
    Controls whether overflowing content is wrapped in a scrollable host instead of being laid out at its full intrinsic size.
    """

    value: str | None = None
    """
    Markdown source rendered by the control.
    """

    text: str | None = None
    """
    Backward-compatible alias for ``value``. When both fields are provided, ``value`` takes precedence and this alias is kept only for compatibility.
    """

    selectable: bool | None = None
    """
    Controls whether rendered text content can be selected and copied by the user.
    """

    use_flutter_markdown: bool | None = None
    """
    Controls whether the native Flutter markdown renderer is used instead of the plain-text fallback path.
    """

    allow_html: bool | None = None
    """
    Controls whether inline or block HTML embedded in the markdown source should be preserved instead of escaped where the runtime supports it.
    """

    render_mode: str | None = None
    """
    Rendering mode used by the runtime, such as ``"markdown"`` or ``"html"``.
    """

    image_directory: str | None = None
    """
    Base directory used to resolve relative image paths referenced from the markdown document.
    """

    base_url: str | None = None
    """
    Base URL forwarded when HTML rendering is enabled.
    """

    soft_line_break: bool | None = None
    """
    Controls whether soft line breaks become explicit line breaks in the rendered output.
    """

    def get_value(self, session: Any) -> str:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> None:
        self.invoke(session, "set_value", {"value": value})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )
