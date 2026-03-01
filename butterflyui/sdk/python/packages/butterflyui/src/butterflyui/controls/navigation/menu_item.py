from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MenuItem"]

class MenuItem(Component):
    """
    Single item entry for use inside a menu or context menu.

    Declares one menu row with a ``label``, optional ``icon``, keyboard
    ``shortcut`` display string, enabled/disabled state, and checked
    ``selected`` state. ``item_id`` is the identifier emitted in selection
    events.

    ```python
    import butterflyui as bui

    bui.MenuItem(
        label="Undo",
        item_id="undo",
        icon="undo",
        shortcut="Ctrl+Z",
    )
    ```

    Args:
        label:
            Display text for the menu item.
        item_id:
            Identifier emitted when the item is selected.
        icon:
            Icon glyph name shown beside the label.
        shortcut:
            Keyboard shortcut string displayed on the right of the item.
        enabled:
            When ``False`` the item is visible but cannot be selected.
        selected:
            When ``True`` the item renders in a checked or highlighted state.
    """

    control_type = "menu_item"

    def __init__(
        self,
        *,
        label: str | None = None,
        item_id: str | None = None,
        icon: str | None = None,
        shortcut: str | None = None,
        enabled: bool | None = None,
        selected: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            id=item_id,
            icon=icon,
            shortcut=shortcut,
            enabled=enabled,
            selected=selected,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
