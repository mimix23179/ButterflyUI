from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Column"]

@butterfly_control('column', field_aliases={'controls': 'children', 'gap': 'spacing'})
class Column(LayoutControl, MultiChildControl):
    """
    Vertical flex container that arranges children in a column.

    The runtime renders a Flutter ``Column`` widget.  Children are laid
    out vertically with configurable ``spacing`` (alias ``gap``) between
    them.  ``main_axis`` controls vertical alignment (start, center, end,
    space_between, etc.) and ``cross_axis`` controls horizontal alignment
    (start, center, end, stretch).  Compound position aliases such as
    ``top_left``, ``middle_center``, and ``bottom_right`` are also accepted;
    on a column the vertical part drives ``main_axis`` and the horizontal
    part drives ``cross_axis``.  Child controls may use ``expanded`` or set
    ``flex`` in their props to fill available space.

    Example:

    ```python
    import butterflyui as bui

    bui.Column(
        bui.Text("First item"),
        bui.Text("Second item"),
        bui.Text("Third item"),
        spacing=12,
        main_axis="center",
    )
    ```
    """

    spacing: float | None = None
    """
    Vertical gap between children in logical pixels.  Aliased as ``gap``.
    """

    main_axis: str | None = None
    """
    Main-axis alignment for the column.  Values: ``start``, ``center``,
    ``end``, ``space_between``, ``space_around``, ``space_evenly``.
    Compound aliases such as ``top_left``, ``top_center``, ``top_right``,
    ``middle_left``, ``middle_center``, ``middle_right``, ``bottom_left``,
    ``bottom_center``, and ``bottom_right`` are also accepted; the column
    uses the vertical component of those values.
    """

    cross_axis: str | None = None
    """
    Cross-axis alignment for children.  Values: ``start``, ``center``,
    ``end``, ``stretch``, ``baseline``.  Compound position aliases such as
    ``top_left`` through ``bottom_right`` are also accepted; the column uses
    the horizontal component of those values.
    """

    horizontal_alignment: Any | None = None
    """
    Horizontal alignment value forwarded to the `column` runtime control.
    """

    vertical_alignment: Any | None = None
    """
    Vertical alignment value forwarded to the `column` runtime control.
    """

    run_alignment: Any | None = None
    """
    Run alignment value forwarded to the `column` runtime control.
    """

    reverse: Any | None = None
    """
    Reverse value forwarded to the `column` runtime control.
    """

    gap: Any | None = None
    """
    Gap value forwarded to the `column` runtime control.
    """
