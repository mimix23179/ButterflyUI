from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..title_control import TitleControl
__all__ = ["MenuItem"]

@butterfly_control('menu_item', field_aliases={'item_id': 'id'})
class MenuItem(LayoutControl, TitleControl):
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

    shortcut: str | None = None
    """
    Keyboard shortcut string displayed on the right of the item.
    """

    selected: bool | None = None
    """
    When ``True`` the item renders in a checked or highlighted state.
    """

    item_id: Any | None = None
    """
    Item id value forwarded to the `menu_item` runtime control.
    """
