from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CommandItem"]

class CommandItem(Component):
    """
    Single command entry for use inside a ``CommandPalette``.

    Declares one command row with a ``label``, optional ``subtitle`` for
    extra context, an ``icon`` glyph name, a ``shortcut`` string displayed
    alongside the label, and an ``enabled`` flag. ``item_id`` is the
    identifier emitted in ``select`` events.

    ```python
    import butterflyui as bui

    bui.CommandItem(
        label="Open File",
        item_id="open_file",
        icon="folder_open",
        shortcut="Ctrl+O",
    )
    ```

    Args:
        label:
            Display label for the command.
        item_id:
            Identifier emitted when the command is selected.
        subtitle:
            Secondary description shown below the label.
        icon:
            Icon glyph name shown beside the label.
        shortcut:
            Keyboard shortcut string displayed on the right side.
        enabled:
            When ``False`` the command is visible but not selectable.
    """

    control_type = "command_item"

    def __init__(
        self,
        *,
        label: str | None = None,
        item_id: str | None = None,
        subtitle: str | None = None,
        icon: str | None = None,
        shortcut: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            id=item_id,
            subtitle=subtitle,
            icon=icon,
            shortcut=shortcut,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
