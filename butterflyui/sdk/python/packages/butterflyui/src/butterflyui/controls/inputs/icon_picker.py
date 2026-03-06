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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `icon_picker` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `icon_picker` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `icon_picker` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `icon_picker` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `icon_picker` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `icon_picker` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `icon_picker` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `icon_picker` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `icon_picker` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `icon_picker` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `icon_picker` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `icon_picker` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `icon_picker` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `icon_picker` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `icon_picker` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `icon_picker` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `icon_picker` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `icon_picker` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `icon_picker` runtime control.
    """
