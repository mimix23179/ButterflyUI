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

    Args:
        child:
            Primary child control rendered when this route is active.
        children:
            Optional child collection for multi-child route layouts.
        route_id:
            Stable route identifier.
        title:
            Route title used by navigation UIs.
        label:
            Optional display label alias.
        layout:
            Child layout hint (for example ``"column"``, ``"row"``,
            ``"stack"``, ``"wrap"``).
        spacing:
            Spacing between children for multi-child layouts.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
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
        super().__init__(
            child=child,
            children=children,
            props=merge_props(
                props,
                route_id=route_id,
                title=title,
                label=label,
                layout=layout,
                spacing=spacing,
                events=events,
                **kwargs,
            ),
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

