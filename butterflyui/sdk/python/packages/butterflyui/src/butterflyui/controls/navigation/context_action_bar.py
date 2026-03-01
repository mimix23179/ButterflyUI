from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .action_bar import ActionBar

__all__ = ["ContextActionBar"]

class ContextActionBar(ActionBar):
    """
    Context-sensitive action bar that surfaces actions for the current selection.

    A specialization of ``ActionBar`` rendered with context-specific styling.
    Inherits all ``ActionBar`` layout properties: ``items``, ``dense``,
    ``spacing``, ``wrap``, ``alignment``, and ``bgcolor``. Typically appears
    below a selected item or region to offer contextually relevant commands.

    ```python
    import butterflyui as bui

    bui.ContextActionBar(
        items=[
            {"id": "cut", "icon": "content_cut", "tooltip": "Cut"},
            {"id": "copy", "icon": "content_copy", "tooltip": "Copy"},
        ],
        events=["action"],
    )
    ```

    Args:
        items:
            List of action item spec mappings to display.
        dense:
            Reduces item height and padding.
        spacing:
            Gap between items in logical pixels.
        wrap:
            When ``True`` items wrap onto additional lines.
        alignment:
            Horizontal alignment of items within the bar.
        bgcolor:
            Background fill color of the bar.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "context_action_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        wrap: bool | None = None,
        alignment: str | None = None,
        bgcolor: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            *children,
            items=items,
            dense=dense,
            spacing=spacing,
            wrap=wrap,
            alignment=alignment,
            bgcolor=bgcolor,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
