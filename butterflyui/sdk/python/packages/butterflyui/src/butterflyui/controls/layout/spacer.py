from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Spacer"]

@butterfly_control('spacer')
class Spacer(LayoutControl):
    """
    Flexible spacer that consumes available space inside a flex layout.

    Similar to ``FlexSpacer`` but exposes runtime control methods
    (``set_flex``, ``get_state``, ``emit``). ``flex`` controls the proportion
    of available space consumed relative to other flexible siblings.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.Spacer(flex=1),
        bui.Text("Right"),
        events=["resize"],
    )
    ```
    """

    def set_flex(self, session: Any, flex: int) -> dict[str, Any]:
        return self.invoke(session, "set_flex", {"flex": int(flex)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
