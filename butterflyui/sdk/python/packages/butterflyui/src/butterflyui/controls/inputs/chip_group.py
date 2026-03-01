from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ChipGroup"]

class ChipGroup(Component):
    """
    Horizontal row of selectable chips built from an options list.

    The runtime renders one ``FilterChip`` per item in ``options``.
    In single-select mode a tap switches the active chip; in
    multi-select mode any number of chips can be active simultaneously.
    The ``value`` (single) or ``values`` (multi) prop reflects the
    current selection.  Selection changes emit a ``change`` event with
    the updated selection.

    ```python
    import butterflyui as bui

    bui.ChipGroup(
        options=["All", "Active", "Archived"],
        value="All",
        multi_select=False,
    )
    ```

    Args:
        options:
            List of chip items.  Each entry may be a plain string or a
            mapping with ``"label"``, ``"value"``, ``"enabled"``, and
            ``"color"`` keys.
        value:
            Currently active value in single-select mode.
        values:
            Currently active values in multi-select mode.
        multi_select:
            If ``True``, multiple chips can be selected simultaneously.
        dense:
            If ``True``, chips use a compact height and tighter padding.
    """
    control_type = "chip_group"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        value: Any | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            value=value,
            values=values,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
