from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Divider"]

@butterfly_control('divider')
class Divider(LayoutControl):
    """
    Thin horizontal or vertical line separator.

    Renders a Material ``Divider`` (horizontal by default) or
    ``VerticalDivider`` when ``vertical`` is ``True``.  Useful for
    visually separating content sections within rows, columns, or
    cards.

    Example:

    ```python
    import butterflyui as bui

    sep = bui.Divider(thickness=2, indent=16, color="#334155")
    ```
    """

    vertical: bool | None = None
    """
    Controls whether renders a vertical divider instead of horizontal. Set it to ``False`` to disable this behavior.
    """

    thickness: float | None = None
    """
    Line thickness in logical pixels.
    """

    indent: float | None = None
    """
    Leading blank space before the divider line.
    """

    end_indent: float | None = None
    """
    Trailing blank space after the divider line.
    """
