from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CommandPalette"]

class CommandPalette(Component):
    """
    Searchable floating command palette overlay.

    The runtime renders a modal search overlay listing ``commands`` or
    ``items``. Typing in the search box filters results. ``open`` shows
    or hides the palette. ``query`` pre-fills the search field. ``title``
    and ``subtitle`` label the overlay header. ``max_results`` caps the
    visible list; ``dismiss_on_select`` closes the palette after selection.

    ```python
    import butterflyui as bui

    bui.CommandPalette(
        commands=[
            {"id": "new_file", "label": "New File"},
            {"id": "open", "label": "Open…"},
        ],
        open=True,
        placeholder="Search commands…",
    )
    ```

    Args:
        commands:
            List of command spec mappings. Alias for ``items``.
        items:
            Alias for ``commands``.
        open:
            When ``True`` the palette overlay is visible.
        query:
            Initial search query text.
        title:
            Heading text displayed inside the palette.
        subtitle:
            Secondary heading shown below the title.
        placeholder:
            Placeholder text for the search input.
        max_results:
            Maximum number of matching results to display.
        dismiss_on_select:
            When ``True`` the palette closes after a command is selected.
    """

    control_type = "command_palette"

    def __init__(
        self,
        *,
        commands: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        open: bool | None = None,
        query: str | None = None,
        title: str | None = None,
        subtitle: str | None = None,
        placeholder: str | None = None,
        max_results: int | None = None,
        dismiss_on_select: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            commands=commands,
            items=items,
            open=open,
            query=query,
            title=title,
            subtitle=subtitle,
            placeholder=placeholder,
            max_results=max_results,
            dismiss_on_select=dismiss_on_select,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
