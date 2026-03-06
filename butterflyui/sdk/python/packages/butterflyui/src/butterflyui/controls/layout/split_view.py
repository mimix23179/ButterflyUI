from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["SplitView"]

@butterfly_control('split_view', field_aliases={'controls': 'children'})
class SplitView(LayoutControl):
    """
    Two-panel layout split along a horizontal or vertical axis.

    The runtime renders two children separated by a divider. ``axis`` sets
    the split direction; ``ratio`` sets the initial fractional split position
    (0.0-1.0). ``draggable`` enables the user to drag the divider.
    ``divider_size`` controls the visible width or height of the divider.
    For bounded drag behavior prefer ``SplitPane``.

    Example:

    ```python
    import butterflyui as bui

    bui.SplitView(
        bui.Text("Left"),
        bui.Text("Right"),
        axis="horizontal",
        ratio=0.5,
        draggable=True,
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    axis: str | None = None
    """
    Split direction. Values: ``"horizontal"``, ``"vertical"``.
    """

    ratio: float | None = None
    """
    Initial fractional position of the divider (0.0-1.0).
    """

    min_ratio: float | None = None
    """
    Minimum allowed divider ratio during drag.
    """

    max_ratio: float | None = None
    """
    Maximum allowed divider ratio during drag.
    """

    draggable: bool | None = None
    """
    When ``True`` the user can drag the divider to resize panels.
    """

    divider_size: float | None = None
    """
    Width or height of the divider affordance in logical pixels.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `split_view` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `split_view` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `split_view` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `split_view` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `split_view` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `split_view` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `split_view` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `split_view` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `split_view` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `split_view` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `split_view` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `split_view` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `split_view` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `split_view` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `split_view` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `split_view` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `split_view` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `split_view` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `split_view` runtime control.
    """
