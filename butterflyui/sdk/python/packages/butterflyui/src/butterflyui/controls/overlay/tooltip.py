from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["Tooltip"]

@butterfly_control('tooltip', field_aliases={'content': 'child'})
class Tooltip(OverlayControl):
    """
    Hover tooltip that displays a short message near its child widget.

    The runtime wraps Flutter's ``Tooltip`` widget. ``message`` is the
    text shown in the tooltip bubble. ``prefer_below`` positions the
    tooltip below the child when ``True`` (default) or above when ``False``.
    ``wait_ms`` sets the hover delay before the tooltip appears.

    Example:

    ```python
    import butterflyui as bui

    bui.Tooltip(
        bui.IconButton(icon="info"),
        message="Show information",
        prefer_below=True,
        wait_ms=500,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    message: str | None = None
    """
    Text displayed inside the tooltip bubble.
    """

    prefer_below: bool | None = None
    """
    When ``True`` the tooltip prefers to appear below the child.
    """

    wait_ms: int | None = None
    """
    Hover delay in milliseconds before the tooltip is shown.
    """

    text: Any | None = None
    """
    Text value rendered by the control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `tooltip` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `tooltip` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `tooltip` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `tooltip` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `tooltip` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `tooltip` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `tooltip` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `tooltip` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `tooltip` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `tooltip` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `tooltip` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `tooltip` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `tooltip` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `tooltip` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `tooltip` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `tooltip` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `tooltip` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `tooltip` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `tooltip` runtime control.
    """
