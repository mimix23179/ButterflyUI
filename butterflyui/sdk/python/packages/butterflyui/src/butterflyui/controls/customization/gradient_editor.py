from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["GradientEditor"]

@butterfly_control('gradient_editor')
class GradientEditor(LayoutControl):
    """
    Interactive gradient editor with an angle slider and colour-stop
    controls.

    The runtime renders a ``Slider`` for the angle (``0``–``360``°) and a
    ``Wrap`` of circular colour-stop chips. Each stop has a position and
    colour. An add button appends stops; individual stops can be removed.
    Emits ``"angle_change"`` and ``"stops_change"`` events.

    ```python
    import butterflyui as bui

    bui.GradientEditor(
        stops=[
            {"position": 0.0, "color": "#7c3aed"},
            {"position": 1.0, "color": "#06b6d4"},
        ],
        angle=135,
    )
    ```
    """

    stops: list[Any] | None = None
    """
    List of colour-stop dicts, each with ``"position"`` (``0.0``–``1.0``) and ``"color"`` (hex string).
    """

    angle: float | None = None
    """
    Initial gradient angle in degrees (``0``–``360``). Defaults to ``0``.
    """

    show_angle: bool | None = None
    """
    Controls whether (default), the angle slider is visible. Set it to ``False`` to disable this behavior.
    """

    show_add: bool | None = None
    """
    Controls whether (default), the "add stop" button is visible. Set it to ``False`` to disable this behavior.
    """

    show_remove: bool | None = None
    """
    Controls whether (default), each stop shows a remove affordance. Set it to ``False`` to disable this behavior.
    """

    live_preview: bool | None = None
    """
    If ``True``, a live gradient preview is rendered alongside the controls.
    """

    export_format: str | None = None
    """
    Hint for the desired export format of gradient data (e.g. ``"css"``, ``"json"``).
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `gradient_editor` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `gradient_editor` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `gradient_editor` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `gradient_editor` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `gradient_editor` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `gradient_editor` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `gradient_editor` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `gradient_editor` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `gradient_editor` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `gradient_editor` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `gradient_editor` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `gradient_editor` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `gradient_editor` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `gradient_editor` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `gradient_editor` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `gradient_editor` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `gradient_editor` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `gradient_editor` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `gradient_editor` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_stops(self, session: Any, stops: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_stops", {"stops": stops})

    def set_angle(self, session: Any, angle: float) -> dict[str, Any]:
        return self.invoke(session, "set_angle", {"angle": float(angle)})

    def add_stop(self, session: Any, position: float, color: Any) -> dict[str, Any]:
        return self.invoke(session, "add_stop", {"position": float(position), "color": color})

    def remove_stop(self, session: Any, index: int) -> dict[str, Any]:
        return self.invoke(session, "remove_stop", {"index": int(index)})
