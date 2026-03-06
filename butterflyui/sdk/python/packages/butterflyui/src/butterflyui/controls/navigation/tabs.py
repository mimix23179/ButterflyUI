from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..multi_child_control import MultiChildControl
__all__ = ["Tabs"]

@butterfly_control('tabs', field_aliases={'controls': 'children'})
class Tabs(LayoutControl, MultiChildControl):
    """
    Horizontal tab bar for switching between views.

    The runtime renders a Flutter tab bar. ``labels`` supplies the tab
    label strings. ``index`` sets the active tab (0-based). ``scrollable``
    allows the tab bar to scroll horizontally when there are more tabs than
    fit in the available width. Positional children can inject custom tab
    content.

    Example:

    ```python
    import butterflyui as bui

    bui.Tabs(
        bui.Text("Content A"),
        bui.Text("Content B"),
        labels=["Tab A", "Tab B"],
        index=0,
    )
    ```
    """

    scrollable: bool | None = None
    """
    When ``True`` the tab bar scrolls horizontally on overflow.
    """

    labels: list[str] | None = None
    """
    Ordered list of label strings rendered by the control.
    """

    index: int | None = None
    """
    Zero-based index of the currently selected tab.
    """

    closable: Any | None = None
    """
    Closable value forwarded to the `tabs` runtime control.
    """

    show_add: Any | None = None
    """
    Show add value forwarded to the `tabs` runtime control.
    """
