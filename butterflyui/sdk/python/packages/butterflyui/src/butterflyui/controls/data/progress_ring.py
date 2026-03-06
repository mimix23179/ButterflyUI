from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["ProgressRing"]

@butterfly_control('progress_ring')
class ProgressRing(LayoutControl):
    """
    Circular progress indicator for determinate or indeterminate tasks.

    ``ProgressRing`` sends the canonical ``progress_ring`` control type and pins
    ``variant="circular"`` / ``circular=True`` so the Flutter side always
    renders a ring. Use ``value`` for determinate progress, or set
    ``indeterminate=True`` for an animated spinner-style state.

    ```python
    import butterflyui as bui

    ring = bui.ProgressRing(value=0.72, label="Syncing", stroke_width=6)
    ```
    """

    value: float | None = None
    """
    Progress value for determinate mode.
    """

    indeterminate: bool | None = None
    """
    If ``True``, renders an animated indeterminate ring.
    """

    label: str | None = None
    """
    Optional text label shown with the indicator.
    """

    stroke_width: float | None = None
    """
    Thickness of the rendered stroke in logical pixels.
    """

    circular: bool | None = None
    """
    Circular value forwarded to the `progress_ring` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `progress_ring` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `progress_ring` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `progress_ring` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `progress_ring` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `progress_ring` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `progress_ring` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `progress_ring` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `progress_ring` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `progress_ring` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `progress_ring` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `progress_ring` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `progress_ring` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `progress_ring` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `progress_ring` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `progress_ring` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `progress_ring` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `progress_ring` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `progress_ring` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `progress_ring` runtime control.
    """

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
