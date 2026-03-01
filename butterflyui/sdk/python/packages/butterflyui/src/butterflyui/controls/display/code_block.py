from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .code_view import CodeView

__all__ = ["CodeBlock"]

class CodeBlock(CodeView):
    """Inline code block alias for ``CodeView``.

    Extends ``CodeView`` and inherits its monospace container, optional
    line numbers, selectable text, and word-wrap behaviour.  This alias
    typically renders with the same dark-background code panel; use it
    when you want a semantic distinction from the full ``CodeView``.

    Example::

        import butterflyui as bui

        block = bui.CodeBlock(
            value="print('Hello, world!')",
            language="python",
            show_line_numbers=True,
        )

    Args:
        value: 
            Source-code string to display.
        text: 
            Alias for ``value``.
        language: 
            Syntax-highlighting language hint (e.g. ``"python"``).
        selectable: 
            If ``True`` (default) the text can be selected.
        wrap: 
            If ``True`` long lines soft-wrap instead of scrolling.
        show_line_numbers: 
            If ``True`` line numbers are prepended.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
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
