from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["ContextMenu"]

@butterfly_control('context_menu', field_aliases={'content': 'child'})
class ContextMenu(OverlayControl):
    """
    Popup context menu bound to a child trigger surface.

    ``ContextMenu`` opens a floating action list on secondary click, long
    press, or tap (depending on ``trigger``/``open_on_tap``). Items may define
    icons, separators, enabled state, and custom payload fields. The runtime
    emits ``open``, ``dismiss``, ``select``, and ``change`` events.

    The menu shell supports styling/shape hints through ``props`` (for example
    ``bgcolor``, ``radius``, ``elevation``), and the trigger surface also
    accepts shared layout hints through ``props``.

    Example:

    ```python
    import butterflyui as bui

    bui.ContextMenu(
        bui.Text("Right-click me"),
        items=[
            {"id": "copy", "label": "Copy"},
            {"id": "paste", "label": "Paste"},
        ],
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    trigger: str | None = None
    """
    Gesture that opens the menu. Values: ``"secondary_tap"``,
    ``"long_press"``.
    """

    open_on_tap: bool | None = None
    """
    When ``True`` a primary tap also opens the context menu.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `context_menu` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `context_menu` runtime control.
    """

    item_bgcolor: Any | None = None
    """
    Item bgcolor value forwarded to the `context_menu` runtime control.
    """

    divider_color: Any | None = None
    """
    Divider color value forwarded to the `context_menu` runtime control.
    """

    backdrop: Any | None = None
    """
    Backdrop value forwarded to the `context_menu` runtime control.
    """

    backdrop_blur: Any | None = None
    """
    Backdrop blur value forwarded to the `context_menu` runtime control.
    """

    use_contextmenu: Any | None = None
    """
    Use contextmenu value forwarded to the `context_menu` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `context_menu` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `context_menu` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `context_menu` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `context_menu` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `context_menu` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `context_menu` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `context_menu` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `context_menu` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `context_menu` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `context_menu` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `context_menu` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `context_menu` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `context_menu` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `context_menu` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `context_menu` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `context_menu` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `context_menu` runtime control.
    """

    align: Any | None = None
    """
    Align value forwarded to the `context_menu` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `context_menu` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `context_menu` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `context_menu` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `context_menu` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `context_menu` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `context_menu` runtime control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `context_menu` runtime control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `context_menu` runtime control.
    """

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_items",
            {"items": [dict(item) for item in items]},
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def open_at(self, session: Any, x: float, y: float) -> dict[str, Any]:
        return self.invoke(session, "open_at", {"x": x, "y": y})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
