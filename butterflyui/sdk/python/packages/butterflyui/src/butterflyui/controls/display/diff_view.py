from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DiffView"]

class DiffView(Component):
    """Side-by-side or unified text diff viewer.

    Computes a character-level diff between ``before`` and ``after``
    using *diff-match-patch* and renders the result in either unified
    (default) or split mode.  Added text is highlighted in green,
    removed text in red, and unchanged text has a transparent
    background.

    Enable ``split`` to show a two-panel side-by-side layout with a
    ``VerticalDivider`` between panes.  Line numbers and word-wrap
    are optional.

    Example::

        import butterflyui as bui

        diff = bui.DiffView(
            before="hello world",
            after="hello brave new world",
            split=True,
            show_line_numbers=True,
        )

    Args:
        before: 
            Original text (left / removed side).
        after: 
            Modified text (right / added side).
        split: 
            If ``True`` the diff renders in a two-panel side-by-side layout; otherwise a single unified diff is shown.
        show_line_numbers: 
            If ``True`` line numbers appear in the gutter.
        wrap: 
            If ``True`` long lines soft-wrap inside each panel.
    """
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
