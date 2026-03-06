from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Route"]


class Route(Component):
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

    title: str | None = None
    """
    Route title used by navigation UIs.
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

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "route"

    def __init__(
        self,
        child: Any | None = None,
        *,
        children: Iterable[Any] | None = None,
        route_id: str | None = None,
        title: str | None = None,
        label: str | None = None,
        layout: str | None = None,
        spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        route_id=route_id,
                        title=title,
                        label=label,
                        layout=layout,
                        spacing=spacing,
                        events=events,
                        **kwargs,
                    )
        super().__init__(
            child=child,
            children=children,
            props=merged,
            style=style,
            strict=strict,
        )

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

