from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

from ..single_child_control import SingleChildControl
__all__ = ["Tooltip"]

@butterfly_control('tooltip', field_aliases={'content': 'child'})
class Tooltip(OverlayControl, SingleChildControl):
    """
    Hover tooltip that displays a short message near its child widget.

    The runtime wraps Flutter's ``Tooltip`` widget. ``message`` is the
    text shown in the tooltip bubble. ``prefer_below`` positions the
    tooltip below the child when ``True`` (default) or above when ``False``.
    ``wait_ms`` sets the hover delay before the tooltip appears.

    Example:

    ```python
    import butterflyui as bui

    bui.Tooltip(
        bui.IconButton(icon="info"),
        message="Show information",
        prefer_below=True,
        wait_ms=500,
    )
    ```
    """

    message: str | None = None
    """
    Text displayed inside the tooltip bubble.
    """

    prefer_below: bool | None = None
    """
    When ``True`` the tooltip prefers to appear below the child.
    """

    wait_ms: int | None = None
    """
    Hover delay in milliseconds before the tooltip is shown.
    """

    text: Any | None = None
    """
    Text value rendered by the control.
    """

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "show", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
