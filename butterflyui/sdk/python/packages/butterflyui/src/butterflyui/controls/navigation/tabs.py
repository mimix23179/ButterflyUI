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

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
