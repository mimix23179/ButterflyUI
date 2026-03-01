from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MarkdownView"]

class MarkdownView(Component):
    """Rendered Markdown content viewer.

    Displays a Markdown string using ``flutter_markdown_plus``.  When
    ``scrollable`` is ``True`` (default) the content is wrapped in a
    scrollable ``Markdown`` widget; otherwise a non-scrollable
    ``MarkdownBody`` is used.  Setting ``selectable`` allows the user
    to select and copy rendered text.

    Use ``get_value`` to retrieve the current Markdown source and
    ``set_value`` to replace it at runtime.

    Example::

        import butterflyui as bui

        view = bui.MarkdownView(
            value="## Features\n- Fast\n- Lightweight",
            selectable=True,
        )

    Args:
        value: 
            Markdown source string.
        text: 
            Alias for ``value``.
        selectable: 
            If ``True`` the rendered text is selectable.
        scrollable: 
            If ``True`` (default) the widget scrolls when content overflows; otherwise it sizes to fit.
    """
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
