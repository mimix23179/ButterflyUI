from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["HoverRegion"]

@butterfly_control('hover_region', field_aliases={'content': 'child'})
class HoverRegion(LayoutControl):
    """
    Tracks pointer hover state over its child and emits hover events.

    Wraps the child in a ``MouseRegion`` that fires ``enter`` and
    ``exit`` events when the pointer moves in or out of the bounds,
    and a ``hover`` event on every pointer movement while inside.
    An optional ``cursor`` override changes the displayed mouse cursor
    while hovering.  When ``opaque`` is ``True`` the region absorbs
    pointer events so they do not reach widgets underneath.

    Example:

    ```python
    import butterflyui as bui

    bui.HoverRegion(
        bui.Card(bui.Text("Hover for info")),
        cursor="click",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    opaque: bool | None = None
    """
    If ``True``, the region absorbs pointer events rather than
    passing them through.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `hover_region` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `hover_region` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `hover_region` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `hover_region` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `hover_region` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `hover_region` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `hover_region` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `hover_region` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `hover_region` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `hover_region` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `hover_region` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `hover_region` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `hover_region` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `hover_region` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `hover_region` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `hover_region` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `hover_region` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `hover_region` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `hover_region` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
