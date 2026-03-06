from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..items_control import ItemsControl
__all__ = ["StatusBar"]

@butterfly_control('status_bar')
class StatusBar(LayoutControl, ItemsControl):
    """
    Horizontal status bar displayed at the bottom of an application window.

    The runtime renders a fixed-height bar at the bottom edge. ``items``
    supply labelled status segments (left or right aligned). ``text`` sets
    a single plain-text message when a full item list is not needed.
    ``dense`` reduces bar height. Runtime invokes support item/text updates
    and arbitrary event emission.

    Shared layout hints are accepted through ``props`` for dock/placement
    control (alignment/position, margin, width/height constraints, radius/clip).

    Example:

    ```python
    import butterflyui as bui

    bui.StatusBar(
        items=[
            {"id": "branch", "label": "main", "icon": "branch"},
            {"id": "errors", "label": "0 errors", "align": "right"},
        ],
    )
    ```
    """

    text: str | None = None
    """
    Simple plain-text status message (used instead of ``items``).
    """

    dense: bool | None = None
    """
    Reduces bar height and item padding.
    """

    align: Any | None = None
    """
    Align value forwarded to the `status_bar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `status_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `status_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `status_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `status_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `status_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `status_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `status_bar` runtime control.
    """

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
