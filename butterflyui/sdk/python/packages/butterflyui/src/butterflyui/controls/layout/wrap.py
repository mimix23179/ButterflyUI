from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Wrap"]

@butterfly_control('wrap', field_aliases={'controls': 'children'})
class Wrap(LayoutControl, MultiChildControl):
    """
    Flow layout that wraps children onto additional lines when space runs out.

    The runtime wraps Flutter's ``Wrap`` widget. ``spacing`` adds inline gaps
    between children; ``run_spacing`` adds gaps between lines (or columns
    when ``direction`` is ``"vertical"``). ``alignment`` controls positioning
    within each run; ``run_alignment`` places the runs along the cross axis.
    ``cross_axis`` sets alignment of children within a single run.
    ``direction`` switches the main axis to horizontal (default) or vertical.

    Example:

    ```python
    import butterflyui as bui

    bui.Wrap(
        *[bui.Chip(label=f"Tag {i}") for i in range(10)],
        spacing=8,
        run_spacing=8,
        alignment="start",
    )
    ```
    """

    spacing: float | None = None
    """
    Gap between consecutive children along the main axis.
    """

    run_spacing: float | None = None
    """
    Gap between consecutive runs along the cross axis.
    """

    run_alignment: str | None = None
    """
    Alignment of runs along the cross axis.
    """

    cross_axis: str | None = None
    """
    Alignment of children within a run along the cross axis.
    """

    direction: str | None = None
    """
    Main-axis direction. Values: ``"horizontal"`` (default),
    ``"vertical"``.
    """

    cross_alignment: Any | None = None
    """
    Cross alignment value forwarded to the `wrap` runtime control.
    """

    vertical_direction: Any | None = None
    """
    Vertical direction value forwarded to the `wrap` runtime control.
    """
