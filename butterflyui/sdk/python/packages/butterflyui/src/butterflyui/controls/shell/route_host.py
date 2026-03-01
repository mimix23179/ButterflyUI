from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RouteHost"]

class RouteHost(Component):
    """
    Route container that can host dynamically injected child content.

    Similar to ``RouteView`` but designed to receive its content from the
    hosting shell rather than declaring it inline. The runtime mounts
    injected content when the route matching ``route_id`` is active.
    ``title`` sets the page title.

    ```python
    import butterflyui as bui

    bui.RouteHost(
        route_id="settings",
        title="Settings",
    )
    ```

    Args:
        route_id:
            Unique identifier for this route, matched by the parent router.
        title:
            Page title string used for navigation history entries.
    """

    control_type = "route_host"

    def __init__(
        self,
        child: Any | None = None,
        *,
        route_id: str | None = None,
        title: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(props, route_id=route_id, title=title, **kwargs)
        super().__init__(child=child, props=merged, style=style, strict=strict)
