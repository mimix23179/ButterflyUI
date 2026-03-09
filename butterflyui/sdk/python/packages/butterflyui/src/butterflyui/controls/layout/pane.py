from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..single_child_control import SingleChildControl
__all__ = ["Pane"]

@butterfly_control('pane', field_aliases={'content': 'child'})
class Pane(LayoutControl, SingleChildControl):
    """
    Named pane for use inside a slot-based layout such as ``DockLayout``.

    Declares a slot-addressed pane. The ``slot`` string tells the parent
    layout where to place this pane (e.g. ``"top"``, ``"left"``,
    ``"fill"``). ``title`` labels the pane in containers that show titles.
    ``size``, ``width``, and ``height`` hint at the preferred dimensions.

    Example:

    ```python
    import butterflyui as bui

    bui.Pane(
        bui.Text("Sidebar"),
        slot="left",
        size=240,
    )
    ```
    """

    slot: str | None = None
    """
    Slot identifier that controls placement within the parent layout.
    """

    title: Any | None = None
    """
    Optional pane title used by parent layouts that render pane headers.
    """

    size: float | str | None = None
    """
    Preferred pane size hint used by split and dock-style parents.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )
