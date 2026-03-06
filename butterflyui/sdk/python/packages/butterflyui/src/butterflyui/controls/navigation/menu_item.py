from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["MenuItem"]

@butterfly_control('menu_item', field_aliases={'item_id': 'id'})
class MenuItem(LayoutControl):
    """
    Single item entry for use inside a menu or context menu.

    Declares one menu row with a ``label``, optional ``icon``, keyboard
    ``shortcut`` display string, enabled/disabled state, and checked
    ``selected`` state. ``item_id`` is the identifier emitted in selection
    events.

    Example:

    ```python
    import butterflyui as bui

    bui.MenuItem(
        label="Undo",
        item_id="undo",
        icon="undo",
        shortcut="Ctrl+Z",
    )
    ```
    """

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    icon: str | None = None
    """
    Icon glyph name shown beside the label.
    """

    shortcut: str | None = None
    """
    Keyboard shortcut string displayed on the right of the item.
    """

    selected: bool | None = None
    """
    When ``True`` the item renders in a checked or highlighted state.
    """

    title: Any | None = None
    """
    Title text or node rendered by the control.
    """

    item_id: Any | None = None
    """
    Item id value forwarded to the `menu_item` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `menu_item` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `menu_item` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `menu_item` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `menu_item` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `menu_item` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `menu_item` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `menu_item` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `menu_item` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `menu_item` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `menu_item` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `menu_item` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `menu_item` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `menu_item` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `menu_item` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `menu_item` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `menu_item` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `menu_item` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `menu_item` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `menu_item` runtime control.
    """
