from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Divider"]

@butterfly_control('divider')
class Divider(LayoutControl):
    """
    Thin horizontal or vertical line separator.

    Renders a Material ``Divider`` (horizontal by default) or
    ``VerticalDivider`` when ``vertical`` is ``True``.  Useful for
    visually separating content sections within rows, columns, or
    cards.

    Example:

    ```python
    import butterflyui as bui

    sep = bui.Divider(thickness=2, indent=16, color="#334155")
    ```
    """

    vertical: bool | None = None
    """
    Controls whether renders a vertical divider instead of horizontal. Set it to ``False`` to disable this behavior.
    """

    thickness: float | None = None
    """
    Line thickness in logical pixels.
    """

    indent: float | None = None
    """
    Leading blank space before the divider line.
    """

    end_indent: float | None = None
    """
    Trailing blank space after the divider line.
    """

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `divider` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `divider` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `divider` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `divider` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `divider` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `divider` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `divider` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `divider` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `divider` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `divider` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `divider` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `divider` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `divider` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `divider` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `divider` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `divider` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `divider` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `divider` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `divider` runtime control.
    """
