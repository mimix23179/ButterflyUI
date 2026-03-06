from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["BreadcrumbBar"]

@butterfly_control('breadcrumb_bar')
class BreadcrumbBar(LayoutControl):
    """
    Interactive breadcrumb bar with path parsing and overflow behaviors.

    Renders clickable path segments from either a slash-delimited ``path`` or
    explicit ``items`` payloads. ``crumbs`` and ``routes`` remain accepted
    aliases for compatibility with previous payload shapes.

    Supports shared placement props via ``props`` (alignment, margin, size
    constraints, radius/clip) so breadcrumb surfaces can be docked in custom
    headers/toolbars.

    Example:

    ```python
    import butterflyui as bui

    bui.BreadcrumbBar(
        path="/home/projects/my-project",
        separator="/",
        dropdown_levels=True,
        events=["navigate"],
    )
    ```
    """

    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    crumbs: list[Mapping[str, Any]] | None = None
    """
    Backward-compatible alias for ``items``. When both fields are provided, ``items`` takes precedence and this alias is kept only for compatibility.
    """

    routes: list[Mapping[str, Any]] | None = None
    """
    Alias for ``items`` used by legacy ``breadcrumbs`` payloads.
    """

    path: str | None = None
    """
    Forward-slash-delimited path string auto-split into segments.
    """

    current_index: int | None = None
    """
    Zero-based index of the currently active segment.
    """

    separator: str | None = None
    """
    String or icon name rendered between segments.
    """

    max_items: int | None = None
    """
    Maximum number of segments to display before truncating.
    """

    dense: bool | None = None
    """
    Reduces segment height and padding.
    """

    dropdown_levels: bool | None = None
    """
    When ``True`` parent levels are shown in a dropdown on overflow.
    """

    show_root: bool | None = None
    """
    When ``True`` the root segment is always visible.
    """

    compact: bool | None = None
    """
    When ``True`` middle segments are collapsed to an ellipsis.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `breadcrumb_bar` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `breadcrumb_bar` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `breadcrumb_bar` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `breadcrumb_bar` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `breadcrumb_bar` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `breadcrumb_bar` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `breadcrumb_bar` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `breadcrumb_bar` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `breadcrumb_bar` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `breadcrumb_bar` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `breadcrumb_bar` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `breadcrumb_bar` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `breadcrumb_bar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `breadcrumb_bar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `breadcrumb_bar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `breadcrumb_bar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `breadcrumb_bar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `breadcrumb_bar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `breadcrumb_bar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `breadcrumb_bar` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `breadcrumb_bar` runtime control.
    """

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def set_index(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "set_index", {"index": int(index)})

    def navigate_path(self, session: Any, path: str) -> dict[str, Any]:
        return self.invoke(session, "navigate_path", {"path": path})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
