from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Pressable"]

@butterfly_control('pressable')
class Pressable(LayoutControl):
    """
    Adds press, hover, and focus interaction states to its child.

    Wraps the child in a Flutter ``GestureDetector`` + ``MouseRegion``
    + ``Focus`` combination.  The interaction state (``pressed``,
    ``hovered``, ``focused``) is tracked and re-broadcast to the
    child so it can apply visual feedback.  Emitted events:

    - ``press``        — pointer-down inside the bounds.
    - ``release``      — pointer-up after a press.
    - ``tap``          — completed tap (press + release).
    - ``hover_enter``  — pointer entered the bounds.
    - ``hover_exit``   — pointer left the bounds.
    - ``focus_gained`` — focus node received keyboard focus.
    - ``focus_lost``   — focus node lost keyboard focus.

    Example:

    ```python
    import butterflyui as bui

    bui.Pressable(
        bui.Container(bui.Text("Press me")),
        hover_enabled=True,
        focus_enabled=True,
    )
    ```
    """

    autofocus: bool | None = None
    """
    If ``True``, the focus node requests focus on mount.
    """

    hover_enabled: bool | None = None
    """
    If ``True``, ``hover_enter`` and ``hover_exit`` events are
    fired.
    """

    focus_enabled: bool | None = None
    """
    If ``True``, ``focus_gained`` and ``focus_lost`` events are
    fired.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `pressable` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `pressable` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `pressable` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `pressable` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `pressable` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `pressable` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `pressable` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `pressable` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `pressable` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `pressable` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `pressable` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `pressable` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `pressable` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `pressable` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `pressable` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `pressable` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `pressable` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `pressable` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `pressable` runtime control.
    """

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
