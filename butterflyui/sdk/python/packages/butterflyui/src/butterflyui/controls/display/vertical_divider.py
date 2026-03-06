from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .divider import Divider
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["VerticalDivider"]

@butterfly_control('vertical_divider')
class VerticalDivider(LayoutControl):
    """
    Vertical line separator for splitting content in horizontal layouts.

    ``VerticalDivider`` is a dedicated wrapper around ``Divider`` that always
    sets ``vertical=True`` and serializes as
    ``control_type="vertical_divider"``.

    Use it between panels, tool groups, or side-by-side cards where a visual
    separator is needed without introducing additional layout controls.

    ```python
    import butterflyui as bui

    bui.Row(
        bui.Text("Left"),
        bui.VerticalDivider(thickness=1.5, indent=8, end_indent=8),
        bui.Text("Right"),
    )
    ```
    """

    thickness: float | None = None
    """
    Line thickness in logical pixels.
    """

    indent: float | None = None
    """
    Leading inset before the divider starts.
    """

    end_indent: float | None = None
    """
    Trailing inset before the divider ends.
    """

    color: Any | None = None
    """
    Divider color value passed to the runtime.
    """

    vertical: bool | None = None
    """
    Vertical value forwarded to the `vertical_divider` runtime control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `vertical_divider` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `vertical_divider` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `vertical_divider` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `vertical_divider` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `vertical_divider` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `vertical_divider` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `vertical_divider` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `vertical_divider` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `vertical_divider` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `vertical_divider` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `vertical_divider` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `vertical_divider` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `vertical_divider` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `vertical_divider` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `vertical_divider` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `vertical_divider` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `vertical_divider` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `vertical_divider` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `vertical_divider` runtime control.
    """
