from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Pressable"]

@butterfly_control('pressable')
class Pressable(LayoutControl):
    """
    Adds press, hover, and focus interaction states to its child.

    Wraps the child in a Flutter ``GestureDetector`` + ``MouseRegion``
    + ``Focus`` combination.  The interaction state (``pressed``,
    ``hovered``, ``focused``) is tracked and re-broadcast to the
    child so it can apply visual feedback.  Emitted events:

    - ``press``        — pointer-down inside the bounds.
    - ``release``      — pointer-up after a press.
    - ``tap``          — completed tap (press + release).
    - ``hover_enter``  — pointer entered the bounds.
    - ``hover_exit``   — pointer left the bounds.
    - ``focus_gained`` — focus node received keyboard focus.
    - ``focus_lost``   — focus node lost keyboard focus.

    Example:

    ```python
    import butterflyui as bui

    bui.Pressable(
        bui.Container(bui.Text("Press me")),
        hover_enabled=True,
        focus_enabled=True,
    )
    ```
    """

    autofocus: bool | None = None
    """
    If ``True``, the focus node requests focus on mount.
    """

    hover_enabled: bool | None = None
    """
    If ``True``, ``hover_enter`` and ``hover_exit`` events are
    fired.
    """

    focus_enabled: bool | None = None
    """
    If ``True``, ``focus_gained`` and ``focus_lost`` events are
    fired.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
