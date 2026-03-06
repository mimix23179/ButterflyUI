from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .emoji_picker import EmojiPicker
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["IconPicker"]

@butterfly_control('icon_picker', positional_fields=('value',))
class IconPicker(FormFieldControl):
    """
    Icon selection panel — a :class:`EmojiPicker` variant for UI icons.

    Inherits the full grid, search, and category behaviour of
    :class:`EmojiPicker` but maps to the ``icon_picker`` control type
    so the Flutter side can render icon glyphs instead of emoji
    characters.  All :class:`EmojiPicker` parameters apply.

    Example:

    ```python
    import butterflyui as bui

    bui.IconPicker(
        show_search=True,
        categories=["interface", "media", "navigation"],
    )
    ```
    """

    categories: list[str] | None = None
    """
    List of icon category names to display.
    """

    recent: list[str] | None = None
    """
    List of recently used icon identifiers.
    """

    skin_tone: str | None = None
    """
    Skin-tone modifier (applicable only when icon set
    supports it).
    """

    show_search: bool | None = None
    """
    If ``True``, a search field is rendered above the grid.
    """

    show_recent: bool | None = None
    """
    If ``True``, a *Recently Used* tab is shown.
    """
