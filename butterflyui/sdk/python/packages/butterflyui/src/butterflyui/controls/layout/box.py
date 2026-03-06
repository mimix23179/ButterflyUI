from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Box"]

@butterfly_control('box', field_aliases={'content': 'child'})
class Box(LayoutControl):
    """
    Simple sized box that constrains and optionally decorates its children.

    The runtime renders a lightweight container. Accepts optional ``width``,
    ``height``, ``padding``, ``margin``, ``alignment``, and ``bgcolor``
    styling values.

    ``Box`` also forwards universal runtime props through ``**kwargs``. This
    includes style/modifier/motion/effects keys plus optional ``icon``,
    ``color``, and ``transparency`` hints used by higher-level styling flows.

    Example:

    ```python
    import butterflyui as bui

    bui.Box(
        bui.Text("Inside a box"),
        width=200,
        height=100,
        bgcolor="#F0F0F0",
        padding=8,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control's content area.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    radius: Any | None = None
    """
    Corner radius used when painting the control.
    """

    border: Any | None = None
    """
    Border descriptor used when rendering the control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    border_width: Any | None = None
    """
    Border width in logical pixels.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `box` runtime control.
    """

    gradient: Any | None = None
    """
    Gradient descriptor used to paint the control.
    """

    image: Any | None = None
    """
    Image descriptor rendered by the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `box` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `box` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `box` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `box` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `box` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `box` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `box` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `box` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `box` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `box` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `box` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `box` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `box` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `box` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `box` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `box` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `box` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `box` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `box` runtime control.
    """
