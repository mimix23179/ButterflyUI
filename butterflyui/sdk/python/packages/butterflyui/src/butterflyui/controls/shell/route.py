from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

from ..title_control import TitleControl
__all__ = ["Route"]

@butterfly_control('route')
class Route(LayoutControl, TitleControl):
    """
    Route node describing one navigable view inside a router.

    ``Route`` is the canonical replacement for legacy ``route_view`` and
    ``route_host`` control wrappers. It can hold inline child content and
    route metadata used by router containers.

    Example:

    ```python
    import butterflyui as bui

    route = bui.Route(
        bui.Text("Dashboard"),
        route_id="dashboard",
        title="Dashboard",
        layout="column",
        events=["change"],
    )
    ```
    """

    route_id: str | None = None
    """
    Stable identifier used to reference this route within navigation state.
    """

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    layout: str | None = None
    """
    Child layout hint (for example ``"column"``, ``"row"``,
    ``"stack"``, ``"wrap"``).
    """

    spacing: float | None = None
    """
    Spacing between children for multi-child layouts.
    """

    def set_route_id(self, session: Any, route_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_route_id", {"route_id": route_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

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
