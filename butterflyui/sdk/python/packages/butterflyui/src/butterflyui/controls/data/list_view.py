from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ListView"]

class ListView(Component):
    """
    Vertical scrollable list container for child controls or data-item
    payloads with optional separator dividers.

    When explicit ``children`` are passed they are rendered directly as
    list rows.  Alternatively an ``items`` payload list lets the runtime
    build rows from data.  Setting ``separator`` to ``True`` inserts
    ``Divider`` widgets between rows.

    ```python
    import butterflyui as bui

    bui.ListView(
        bui.ListTile(title="Item 1"),
        bui.ListTile(title="Item 2"),
        bui.ListTile(title="Item 3"),
        separator=True,
    )
    ```

    Args:
        items: 
            Data-item payloads used to build rows when no explicit children are given.
        separator: 
            If ``True``, a ``Divider`` is inserted between each row.
    """

    control_type = "list_view"

    def __init__(
        self,
        *children: Any,
        items: list[Any] | None = None,
        separator: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, items=items, separator=separator, **kwargs)
        super().__init__(*children, props=merged, style=style, strict=strict)
