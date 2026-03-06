from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .divider import Divider
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["VerticalDivider"]

@butterfly_control('vertical_divider')
class VerticalDivider(LayoutControl):
    """
    Vertical line separator for splitting content in horizontal layouts.

    ``VerticalDivider`` is a dedicated wrapper around ``Divider`` that always
    sets ``vertical=True`` and serializes as
    ``control_type="vertical_divider"``.

    Use it between panels, tool groups, or side-by-side cards where a visual
    separator is needed without introducing additional layout controls.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.VerticalDivider(thickness=1.5, indent=8, end_indent=8),
        bui.Text("Right"),
    )
    ```
    """

    thickness: float | None = None
    """
    Line thickness in logical pixels.
    """

    indent: float | None = None
    """
    Leading inset before the divider starts.
    """

    end_indent: float | None = None
    """
    Trailing inset before the divider ends.
    """

    vertical: bool | None = None
    """
    Vertical value forwarded to the `vertical_divider` runtime control.
    """
