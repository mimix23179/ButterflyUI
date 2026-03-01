from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MenuBar"]

class MenuBar(Component):
    """
    Application-level horizontal menu bar with drop-down menus.

    The runtime renders a classic top menu bar. ``menus`` / ``items`` supply
    top-level menu specs; each entry may contain a ``label`` and nested
    ``children`` for sub-menus. Positional children can also inject custom
    widgets into the bar. ``dense`` reduces the bar height; ``height``
    overrides it explicitly.

    ```python
    import butterflyui as bui

    bui.MenuBar(
        menus=[
            {"label": "File", "children": [{"label": "New", "id": "new"}, {"label": "Open", "id": "open"}]},
            {"label": "Edit", "children": [{"label": "Undo", "id": "undo"}]},
        ],
    )
    ```

    Args:
        menus:
            List of top-level menu spec mappings. Alias for ``items``.
        items:
            Alias for ``menus``.
        dense:
            Reduces bar height and menu item padding.
        height:
            Explicit bar height in logical pixels.
    """

    control_type = "menu_bar"

    def __init__(
        self,
        *children: Any,
        menus: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        dense: bool | None = None,
        height: float | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            menus=menus,
            items=items,
            dense=dense,
            height=height,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
