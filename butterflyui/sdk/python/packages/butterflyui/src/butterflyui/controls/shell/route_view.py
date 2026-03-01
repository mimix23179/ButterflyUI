from __future__ import annotations
from collections.abc import Iterable, Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RouteView"]

class RouteView(Component):
    """
    Named route slot that lazily renders its content inside a ``Router``.

    The runtime associates a widget subtree with a named route. When the
    parent ``Router`` activates this route by ``route_id`` the content is
    mounted; otherwise it is unmounted (unless ``keep_alive`` is set on the
    router). ``title`` sets the page title used for navigation history.

    ```python
    import butterflyui as bui

    bui.RouteView(
        bui.Text("Home page"),
        route_id="home",
        title="Home",
    )
    ```

    Args:
        route_id:
            Unique identifier for this route, matched by the parent router.
        title:
            Page title string used for navigation history entries.
    """

    control_type = "route_view"

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
