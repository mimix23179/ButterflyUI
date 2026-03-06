from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["RailNavigation"]

@butterfly_control('rail_navigation')
class RailNavigation(LayoutControl):
    """
    Vertical navigation rail with selectable destinations and icon states.

    ``RailNavigation`` is suitable for desktop/tablet shell layouts where
    major sections are represented as left or right rail destinations.
    Supports dense mode, extended mode, and runtime selection updates.

    Item mappings may define ``icon`` and ``selected_icon`` descriptors along
    with ``id``, ``label``, and ``enabled`` state.

    Shared frame/layout hints are accepted through ``props`` to place rails
    in custom shells (alignment, margin, sizing constraints, radius/clip).

    Example:

    ```python
    import butterflyui as bui

    bui.RailNavigation(
        items=[
            {"id": "inbox", "label": "Inbox", "icon": "inbox"},
            {"id": "sent", "label": "Sent", "icon": "send"},
            {"id": "archive", "label": "Archive", "icon": "archive"},
        ],
        selected_id="inbox",
        extended=True,
        events=["select", "change"],
    )
    ```
    """

    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    selected_id: str | None = None
    """
    Identifier of the currently selected item, tab, route, or navigation destination.
    """

    dense: bool | None = None
    """
    Enables compact spacing and icon sizing.
    """

    extended: bool | None = None
    """
    Expands rail width and displays labels inline.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `rail_navigation` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `rail_navigation` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `rail_navigation` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `rail_navigation` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `rail_navigation` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `rail_navigation` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `rail_navigation` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `rail_navigation` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `rail_navigation` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `rail_navigation` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `rail_navigation` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `rail_navigation` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `rail_navigation` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `rail_navigation` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `rail_navigation` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `rail_navigation` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `rail_navigation` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `rail_navigation` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `rail_navigation` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `rail_navigation` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `rail_navigation` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `rail_navigation` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `rail_navigation` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `rail_navigation` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `rail_navigation` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `rail_navigation` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `rail_navigation` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `rail_navigation` runtime control.
    """

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

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

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
