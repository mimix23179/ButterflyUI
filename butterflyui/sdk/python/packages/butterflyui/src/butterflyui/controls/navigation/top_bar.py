from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["TopBar"]

@butterfly_control('top_bar')
class TopBar(LayoutControl):
    """
    Application top bar with optional inline search and trailing actions.

    The runtime renders a top navigation surface composed of ``title`` and
    optional ``subtitle`` plus a search field and trailing ``actions``.
    ``center_title`` controls title alignment.

    ``TopBar`` uses the same runtime renderer as ``AppBar`` and supports
    shared layout hints through ``props`` (alignment/position, margin,
    constraints, radius, and clip behavior).

    Example:

    ```python
    import butterflyui as bui

    bui.TopBar(
        title="Explorer",
        show_search=True,
        search_placeholder="Search files...",
        actions=[{"id": "filter", "icon": "filter_list"}],
        events=["search", "action"],
    )
    ```
    """

    title: str | None = None
    """
    Primary heading text rendered by the control.
    """

    subtitle: str | None = None
    """
    Optional secondary text shown below the title.
    """

    center_title: bool | None = None
    """
    Centers the title when ``True``.
    """

    show_search: bool | None = None
    """
    Shows an inline search field when ``True``.
    """

    search_value: str | None = None
    """
    Current text value shown in the control's search input.
    """

    search_placeholder: str | None = None
    """
    Placeholder text for the search field.
    """

    actions: list[Any] | None = None
    """
    Ordered list of action descriptors rendered or triggered by this control. Each entry should match the runtime payload shape expected for the control type.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    elevation: Any | None = None
    """
    Elevation value forwarded to the `top_bar` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `top_bar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `top_bar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `top_bar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `top_bar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `top_bar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `top_bar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `top_bar` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `top_bar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `top_bar` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `top_bar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `top_bar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `top_bar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `top_bar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `top_bar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `top_bar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `top_bar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `top_bar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `top_bar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `top_bar` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `top_bar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `top_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `top_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `top_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `top_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `top_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `top_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `top_bar` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `top_bar` runtime control.
    """

    def set_title(self, session: Any, title: str) -> dict[str, Any]:
        return self.invoke(session, "set_title", {"title": title})

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

    def trigger(
        self,
        session: Any,
        event: str = "change",
        **payload: Any,
    ) -> dict[str, Any]:
        return self.emit(session, event, payload)
