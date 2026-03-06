from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .button import Button
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["IconButton"]

@butterfly_control('icon_button', positional_fields=('icon',))
class IconButton(ButtonControl):
    """
    Tappable icon-only button control.

    ``IconButton`` is the icon-focused member of the button family. It keeps
    the full action/event behavior of :class:`Button` while prioritizing icon
    payloads over text captions. The runtime can resolve icon name strings,
    integer code points, and compatible icon payload objects.

    Use this for toolbar buttons, compact overlay actions, or quick actions
    where a label would add unnecessary visual weight.

    Example:

    ```python
    import butterflyui as bui

    bui.IconButton(
        icon="delete",
        tooltip="Delete item",
        color="#FF4D6D",
        action_id="delete_current_item",
    )
    ```
    """

    color: Any | None = None
    """
    Icon color value accepted by runtime.
    """

    glyph: Any | None = None
    """
    Glyph value forwarded to the `icon_button` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `icon_button` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `icon_button` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `icon_button` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `icon_button` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `icon_button` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `icon_button` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `icon_button` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `icon_button` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `icon_button` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `icon_button` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `icon_button` runtime control.
    """

    icon_size: float | None = None
    """
    Icon size value forwarded to the `icon_button` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `icon_button` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `icon_button` runtime control.
    """

    transparency: float | None = None
    """
    Transparency value forwarded to the `icon_button` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `icon_button` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `icon_button` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `icon_button` runtime control.
    """
