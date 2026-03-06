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

    glyph: Any | None = None
    """
    Glyph value forwarded to the `icon_button` runtime control.
    """
