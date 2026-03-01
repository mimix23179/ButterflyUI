from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .emoji_picker import EmojiPicker

__all__ = ["IconPicker"]

class IconPicker(EmojiPicker):
    """
    Icon selection panel — a :class:`EmojiPicker` variant for UI icons.

    Inherits the full grid, search, and category behaviour of
    :class:`EmojiPicker` but maps to the ``icon_picker`` control type
    so the Flutter side can render icon glyphs instead of emoji
    characters.  All :class:`EmojiPicker` parameters apply.

    ```python
    import butterflyui as bui

    bui.IconPicker(
        show_search=True,
        categories=["interface", "media", "navigation"],
    )
    ```

    Args:
        value:
            Pre-selected icon identifier string.
        categories:
            List of icon category names to display.
        recent:
            List of recently used icon identifiers.
        skin_tone:
            Skin-tone modifier (applicable only when icon set
            supports it).
        show_search:
            If ``True``, a search field is rendered above the grid.
        show_recent:
            If ``True``, a *Recently Used* tab is shown.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "icon_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        categories: list[str] | None = None,
        recent: list[str] | None = None,
        skin_tone: str | None = None,
        show_search: bool | None = None,
        show_recent: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            categories=categories,
            recent=recent,
            skin_tone=skin_tone,
            show_search=show_search,
            show_recent=show_recent,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
