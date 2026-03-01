from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Row"]

class Row(Component):
    """Horizontal flex container that arranges children in a row.

    The runtime renders a Flutter ``Row`` widget.  Children are laid
    out horizontally with configurable ``spacing`` (alias ``gap``) between
    them.  ``main_axis`` controls horizontal alignment (start, center, end,
    space_between, etc.) and ``cross_axis`` controls vertical alignment
    (start, center, end, stretch).  Child controls may use ``expanded``
    or set ``flex`` in their props to fill available space.

    Example::

        import butterflyui as bui

        bui.Row(
            bui.Text("Left"),
            bui.Text("Center"),
            bui.Text("Right"),
            spacing=16,
            main_axis="space_between",
        )

    Args:
        spacing:
            Horizontal gap between children in logical pixels.  Aliased as ``gap``.
        main_axis:
            Main-axis alignment for the row.  Values: ``start``, ``center``,
            ``end``, ``space_between``, ``space_around``, ``space_evenly``.
        cross_axis:
            Cross-axis alignment for children.  Values: ``start``, ``center``,
            ``end``, ``stretch``, ``baseline``.
    """

    control_type = "row"

    def __init__(
        self,
        *children: Any,
        spacing: float | None = None,
        gap: float | None = None,
        main_axis: str | None = None,
        cross_axis: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            spacing=spacing if spacing is not None else gap,
            gap=gap if gap is not None else spacing,
            main_axis=main_axis,
            cross_axis=cross_axis,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)
