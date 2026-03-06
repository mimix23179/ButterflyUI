from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Spacer"]

@butterfly_control('spacer')
class Spacer(LayoutControl):
    """
    Flexible spacer that consumes available space inside a flex layout.

    Similar to ``FlexSpacer`` but exposes runtime control methods
    (``set_flex``, ``get_state``, ``emit``). ``flex`` controls the proportion
    of available space consumed relative to other flexible siblings.

    Example:

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.Spacer(flex=1),
        bui.Text("Right"),
        events=["resize"],
    )
    ```
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `spacer` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `spacer` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `spacer` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `spacer` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `spacer` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `spacer` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `spacer` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `spacer` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `spacer` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `spacer` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `spacer` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `spacer` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `spacer` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `spacer` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `spacer` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `spacer` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `spacer` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `spacer` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `spacer` runtime control.
    """

    def set_flex(self, session: Any, flex: int) -> dict[str, Any]:
        return self.invoke(session, "set_flex", {"flex": int(flex)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
