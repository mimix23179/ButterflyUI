from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["BorderEffect", "Border"]

@butterfly_control('border')
class BorderEffect(LayoutControl):
    """
    Wrap a child control in a configurable border decoration.
    """

    color: Any | None = None
    """
    Border color applied around the wrapped child.
    """

    radius: float | None = None
    """
    Corner radius of the border decoration.
    """

    side: str | None = None
    """
    Single-side shortcut, such as ``"top"`` or ``"bottom"``.
    """

    sides: Mapping[str, Any] | None = None
    """
    Per-side border payload for advanced border configuration.
    """

    animated: bool | None = None
    """
    Whether border changes should animate.
    """

    duration_ms: int | None = None
    """
    Duration of the border animation in milliseconds.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `border` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `border` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `border` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `border` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `border` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `border` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `border` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `border` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `border` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `border` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `border` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `border` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `border` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `border` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `border` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `border` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `border` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `border` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `border` runtime control.
    """

    def set_style(self, session: Any, **style_props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_style", style_props)

Border = BorderEffect
