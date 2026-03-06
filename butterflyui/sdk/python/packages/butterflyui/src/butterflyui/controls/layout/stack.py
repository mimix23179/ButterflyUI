from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Stack"]

@butterfly_control('stack', field_aliases={'controls': 'children'})
class Stack(LayoutControl):
    """
    Overlapping-children container that layers widgets on top of each other.

    The runtime wraps Flutter's ``Stack`` widget. ``alignment`` positions
    un-positioned children within the stack bounds. ``fit`` controls how the
    stack sizes itself: ``"loose"`` (shrink to the largest child) or
    ``"expand"`` (fills the parent). ``clip`` enables clipping of children
    that overflow the stack bounds.

    Example:

    ```python
    import butterflyui as bui

    bui.Stack(
        bui.Image(src="background.png"),
        bui.Text("Overlay text"),
        alignment="center",
    )
    ```
    """

    controls: list[Any] | None = None
    """
    Child controls rendered in order by this control.
    """

    fit: str | None = None
    """
    How the stack sizes itself. Values: ``"loose"``, ``"expand"``.
    """

    clip: bool | None = None
    """
    When ``True`` children that overflow the stack bounds are clipped.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `stack` runtime control.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `stack` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `stack` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `stack` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `stack` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `stack` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `stack` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `stack` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `stack` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `stack` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `stack` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `stack` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `stack` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `stack` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `stack` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `stack` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `stack` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `stack` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `stack` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `stack` runtime control.
    """
