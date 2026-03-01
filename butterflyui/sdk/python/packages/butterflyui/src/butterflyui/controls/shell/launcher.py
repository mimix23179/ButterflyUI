from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Launcher"]

class Launcher(Component):
    """
    App-launcher grid or list that displays a collection of launchable items.

    The runtime renders a configurable grid or list of launcher entries.
    ``items`` provides the list of item specs (id, label, icon, etc.).
    ``selected_id`` marks the initially selected item. ``layout`` switches
    between ``"grid"`` and ``"list"`` views. ``columns`` sets the number
    of columns in grid mode.

    ```python
    import butterflyui as bui

    bui.Launcher(
        items=[
            {"id": "files", "label": "Files", "icon": "folder"},
            {"id": "settings", "label": "Settings", "icon": "settings"},
        ],
        layout="grid",
        columns=4,
    )
    ```

    Args:
        items:
            List of launcher item spec mappings.
        selected_id:
            ID of the initially selected launcher item.
        layout:
            Display layout. Values: ``"grid"``, ``"list"``.
        columns:
            Number of columns when ``layout`` is ``"grid"``.
    """

    control_type = "launcher"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        layout: str | None = None,
        columns: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            selected_id=selected_id,
            layout=layout,
            columns=columns,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
