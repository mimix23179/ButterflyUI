from __future__ import annotations

from collections.abc import Iterable, Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["Route"]

@butterfly_control('route')
class Route(LayoutControl):
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

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `route` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `route` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `route` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `route` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `route` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `route` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `route` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `route` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `route` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `route` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `route` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `route` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `route` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `route` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `route` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `route` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `route` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `route` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `route` runtime control.
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
