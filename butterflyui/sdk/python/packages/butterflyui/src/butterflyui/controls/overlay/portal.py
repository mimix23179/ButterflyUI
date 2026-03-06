from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..overlay_control import OverlayControl

__all__ = ["Portal"]

@butterfly_control('portal', field_aliases={'content': 'child'}, positional_fields=('portal',))
class Portal(OverlayControl):
    """
    Renders portal content into a separate overlay layer above the widget tree.

    The runtime keeps the ``child`` widget in the normal layout tree but
    projects the ``portal`` content to a top-level overlay layer. ``open``
    controls whether the portal overlay is visible. ``dismissible`` closes
    it on outside tap. ``passthrough`` allows pointer events to reach
    widgets behind the portal. ``alignment`` and ``offset`` position the
    portal content.

    Example:

    ```python
    import butterflyui as bui

    bui.Portal(
        child=bui.Button(label="Open"),
        portal=bui.Text("Portal content"),
        open=True,
        alignment="center",
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    portal: Any | None = None
    """
    The widget projected into the top-level overlay layer.
    """

    passthrough: bool | None = None
    """
    When ``True`` pointer events pass through to widgets below.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `portal` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `portal` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `portal` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `portal` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `portal` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `portal` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `portal` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `portal` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `portal` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `portal` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `portal` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `portal` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `portal` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `portal` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `portal` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `portal` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `portal` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `portal` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `portal` runtime control.
    """
