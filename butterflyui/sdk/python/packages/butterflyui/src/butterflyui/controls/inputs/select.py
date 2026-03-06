from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl

__all__ = ["Select"]

@butterfly_control('select')
class Select(SelectionControl):
    """
    Drop-down select control for choosing one item from a list.

    Renders a Flutter ``DropdownButton`` (or equivalent) that opens an
    option list overlay on tap.  The selected item is identified by
    ``value`` or ``index``.  Selecting a different option emits a
    ``change`` event carrying the new ``value`` and ``index``.

    Example:

    ```python
    import butterflyui as bui

    bui.Select(
        options=["Small", "Medium", "Large"],
        value="Medium",
        label="Size",
    )
    ```
    """

    index: int | None = None
    """
    Zero-based index of the initially selected option.
    """

    hint: str | None = None
    """
    Hint text shown when no option is selected.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `select` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `select` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `select` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `select` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `select` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `select` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `select` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `select` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `select` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `select` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `select` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `select` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `select` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `select` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `select` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `select` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `select` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `select` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `select` runtime control.
    """
