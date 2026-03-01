from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GridView"]

class GridView(Component):
    """
    Multi-column grid layout that arranges child controls or item
    payloads into a configurable number of columns.

    When explicit ``children`` are supplied they are rendered directly as
    grid tiles.  Alternatively, an ``items`` payload list can be passed
    to let the runtime build tiles from data.  The ``columns`` parameter
    controls how many tiles appear per row.

    ```python
    import butterflyui as bui

    bui.GridView(
        bui.Text("A"), bui.Text("B"), bui.Text("C"), bui.Text("D"),
        columns=2,
    )
    ```

    Args:
        items: 
            Data-item payloads used by the runtime to construct tiles when no explicit children are given.
        columns: 
            Number of grid columns.  Defaults to the runtime's layout heuristic when ``None``.
    """

    control_type = "grid_view"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        columns: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, items=items, columns=columns, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)
