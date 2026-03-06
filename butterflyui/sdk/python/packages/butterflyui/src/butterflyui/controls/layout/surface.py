from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Surface"]

@butterfly_control('surface', field_aliases={'content': 'child'})
class Surface(LayoutControl):
    """
    Elevated surface card with background color, border, and corner radius.

    A simplified decorated container for material-style surfaces. Accepts
    ``padding`` for inner spacing, ``radius`` for corner rounding, ``bgcolor``
    for the background fill, and ``border_color``/``border_width`` for an
    optional border stroke.

    ``Surface`` participates in the universal styling/effects pipeline exposed
    by the shared renderer. You can pass the same cross-control props used by
    Candy/Skins/Style/Modifier/Gallery through ``**kwargs`` (for example
    ``variant``, ``classes``, ``modifiers``, ``motion``, ``effects``,
    ``on_hover_modifiers``, ``icon``, ``color``, ``transparency``).

    Example:

    ```python
    import butterflyui as bui

    bui.Surface(
        bui.Text("Card content"),
        radius=12,
        bgcolor="#FFFFFF",
        padding=16,
    )
    ```
    """

    content: Any | None = None
    """
    Primary child control rendered inside this control.
    """

    radius: float | None = None
    """
    Corner radius in logical pixels.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control's content area.
    """

    border_color: Any | None = None
    """
    Border color applied to the outer edge of the rendered control or decorative surface.
    """

    border_width: float | None = None
    """
    Border stroke width in logical pixels.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    elevation: Any | None = None
    """
    Elevation value forwarded to the `surface` runtime control.
    """

    border: Any | None = None
    """
    Border descriptor used when rendering the control.
    """

    shadow_color: Any | None = None
    """
    Shadow color value forwarded to the `surface` runtime control.
    """

    clip_behavior: Any | None = None
    """
    Clip behavior value forwarded to the `surface` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `surface` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `surface` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `surface` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `surface` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `surface` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `surface` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `surface` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `surface` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `surface` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `surface` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `surface` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `surface` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `surface` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `surface` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `surface` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `surface` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `surface` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `surface` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `surface` runtime control.
    """
