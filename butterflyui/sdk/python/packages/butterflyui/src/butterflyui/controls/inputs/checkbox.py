from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..toggle_control import ToggleControl

__all__ = ["Checkbox"]

@butterfly_control('checkbox', positional_fields=('value',))
class Checkbox(ToggleControl):
    """
    Single boolean check-box with an optional text label.

    Renders a Flutter ``Checkbox`` (or ``CheckboxListTile`` when
    ``label`` is provided).  When ``tristate`` is ``True`` the control
    cycles through ``True``, ``False``, and ``None`` (indeterminate).
    Toggling the checkbox emits a ``change`` event with the new value.

    Example:

    ```python
    import butterflyui as bui

    bui.Checkbox(value=True, label="Accept terms")
    ```
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `checkbox` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `checkbox` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `checkbox` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `checkbox` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `checkbox` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `checkbox` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `checkbox` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `checkbox` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `checkbox` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `checkbox` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `checkbox` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `checkbox` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `checkbox` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `checkbox` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `checkbox` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `checkbox` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `checkbox` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `checkbox` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `checkbox` runtime control.
    """
