from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..toggle_control import ToggleControl


__all__ = ["Switch"]

@butterfly_control('switch', positional_fields=('value',))
class Switch(ToggleControl):
    """
    Boolean switch input with optional segmented presentation.

    ``Switch`` now also covers segmented-switch use cases through ``mode`` and
    ``segments``. In default mode it behaves like a standard on/off toggle;
    segmented mode allows richer labels and grouped state presentation.

    Example:

    ```python
    import butterflyui as bui

    toggle = bui.Switch(
        value=True,
        label="Notifications",
        on_label="On",
        off_label="Off",
    )
    ```
    """

    inline: bool | None = None
    """
    If ``True``, aligns label and switch inline.
    """

    mode: str | None = None
    """
    Rendering mode (for example ``"toggle"`` or ``"segmented"``
    depending on renderer support).
    """

    on_label: str | None = None
    """
    Label text shown when the control is in its on or enabled state.
    """

    off_label: str | None = None
    """
    Label text shown when the control is in its off or disabled state.
    """

    segments: list[Any] | None = None
    """
    Segment descriptors for segmented presentation mode.
    """

    options: Any | None = None
    """
    Option descriptors rendered by the control.
    """

    index: Any | None = None
    """
    Index value forwarded to the `switch` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `switch` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `switch` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `switch` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `switch` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `switch` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `switch` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `switch` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `switch` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `switch` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `switch` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `switch` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `switch` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `switch` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `switch` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `switch` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `switch` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `switch` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `switch` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `switch` runtime control.
    """

    def set_value(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
