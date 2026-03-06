from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Row"]

@butterfly_control('row', field_aliases={'controls': 'children', 'gap': 'spacing'})
class Row(LayoutControl, MultiChildControl):
    """
    Horizontal flex container that arranges children in a row.

    The runtime renders a Flutter ``Row`` widget.  Children are laid
    out horizontally with configurable ``spacing`` (alias ``gap``) between
    them.  ``main_axis`` controls horizontal alignment (start, center, end,
    space_between, etc.) and ``cross_axis`` controls vertical alignment
    (start, center, end, stretch).  Child controls may use ``expanded``
    or set ``flex`` in their props to fill available space.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.Text("Center"),
        bui.Text("Right"),
        spacing=16,
        main_axis="space_between",
    )
    ```
    """

    spacing: float | None = None
    """
    Horizontal gap between children in logical pixels.  Aliased as ``gap``.
    """

    main_axis: str | None = None
    """
    Main-axis alignment for the row.  Values: ``start``, ``center``,
    ``end``, ``space_between``, ``space_around``, ``space_evenly``.
    """

    cross_axis: str | None = None
    """
    Cross-axis alignment for children.  Values: ``start``, ``center``,
    ``end``, ``stretch``, ``baseline``.
    """

    horizontal_alignment: Any | None = None
    """
    Horizontal alignment value forwarded to the `row` runtime control.
    """

    vertical_alignment: Any | None = None
    """
    Vertical alignment value forwarded to the `row` runtime control.
    """

    run_alignment: Any | None = None
    """
    Run alignment value forwarded to the `row` runtime control.
    """

    wrap: Any | None = None
    """
    Wrap value forwarded to the `row` runtime control.
    """

    reverse: Any | None = None
    """
    Reverse value forwarded to the `row` runtime control.
    """

    gap: Any | None = None
    """
    Gap value forwarded to the `row` runtime control.
    """
