from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["HoverRegion"]

@butterfly_control('hover_region', field_aliases={'content': 'child'})
class HoverRegion(LayoutControl, SingleChildControl):
    """
    Tracks pointer hover state over its child and emits hover events.

    Wraps the child in a ``MouseRegion`` that fires ``enter`` and
    ``exit`` events when the pointer moves in or out of the bounds,
    and a ``hover`` event on every pointer movement while inside.
    An optional ``cursor`` override changes the displayed mouse cursor
    while hovering.  When ``opaque`` is ``True`` the region absorbs
    pointer events so they do not reach widgets underneath.

    Example:

    ```python
    import butterflyui as bui

    bui.HoverRegion(
        bui.Card(bui.Text("Hover for info")),
        cursor="click",
    )
    ```
    """

    opaque: bool | None = None
    """
    If ``True``, the region absorbs pointer events rather than
    passing them through.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
