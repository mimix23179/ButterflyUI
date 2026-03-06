from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..scrollable_control import ScrollableControl

from ..multi_child_control import MultiChildControl
from ..items_control import ItemsControl
__all__ = ["ListView"]

@butterfly_control('list_view', field_aliases={'controls': 'children'})
class ListView(ScrollableControl, MultiChildControl, ItemsControl):
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
    """

    separator: bool | None = None
    """
    If ``True``, a ``Divider`` is inserted between each row.
    """
