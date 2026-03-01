from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props
from .route_view import RouteView

__all__ = ["Route"]

class Route(RouteView):
    """
    Route slot with optional event emission for navigation lifecycle hooks.

    A specialization of ``RouteView`` that adds ``events`` support so
    Python can receive route-activation and deactivation notices.
    Inherits ``route_id`` and ``title`` from ``RouteView``.

    ```python
    import butterflyui as bui

    bui.Route(
        bui.Text("Dashboard"),
        route_id="dashboard",
        title="Dashboard",
        events=["activate", "deactivate"],
    )
    ```

    Args:
        route_id:
            Unique identifier for this route, matched by the parent router.
        title:
            Page title string used for navigation history entries.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "route"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            route_id=route_id,
            title=title,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_route_id(self, session: Any, route_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_route_id", {"route_id": route_id})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
