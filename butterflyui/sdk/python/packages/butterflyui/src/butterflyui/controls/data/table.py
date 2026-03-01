from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Table"]

class Table(Component):
    """
    Dual-axis scrollable table backed by Flutter’s ``DataTable`` with
    scroll-position invoke commands.

    The runtime renders a ``DataTable`` inside nested horizontal and
    vertical ``SingleChildScrollView`` widgets.  ``columns`` are used
    as plain header labels and ``rows`` as lists of cell values.
    Striped rows, dense mode, and header visibility are supported.
    Tapping a row emits ``"row_tap"`` with the ``index`` and ``row``
    values.  Scroll events (``"scroll_start"``, ``"scroll"``,
    ``"scroll_end"``) can be subscribed to via the ``events`` prop.
    Programmatic scrolling is available through ``scroll_to``,
    ``scroll_by``, ``scroll_to_start``, ``scroll_to_end``, and
    ``get_scroll_metrics`` invoke methods.

    ```python
    import butterflyui as bui

    bui.Table(
        columns=["Name", "Role", "Status"],
        rows=[
            ["Alice", "Engineer", "Active"],
            ["Bob", "Designer", "Away"],
        ],
    )
    ```

    Args:
        columns: 
            Column header labels — a list of plain strings.
        rows: 
            Row data — a list of lists where each inner list contains cell values aligned to ``columns``.
    """

    control_type = "table"

    def __init__(
        self,
        *,
        columns: list[Any] | None = None,
        rows: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, columns=columns, rows=rows, **kwargs)
        super().__init__(props=merged, style=style, strict=strict)
