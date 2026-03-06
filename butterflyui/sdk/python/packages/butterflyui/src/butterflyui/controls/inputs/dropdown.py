from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl

__all__ = ["Dropdown"]

@butterfly_control('dropdown', positional_fields=('value',))
class Dropdown(SelectionControl):
    """
    Non-editable drop-down select rendered as a ``Combobox``.

    Extends :class:`Combobox` but maps to the ``dropdown`` control type
    on the Flutter side, which may render as a pure select-only
    dropdown rather than an editable text field.  Supports the same
    option, grouping, async-source, and imperative methods as
    :class:`Combobox`.

    Example:

    ```python
    import butterflyui as bui

    bui.Dropdown(
        options=["Small", "Medium", "Large"],
        label="Size",
        value="Medium",
    )
    ```
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    List of grouped option sections, each with
    ``"label"`` and ``"options"`` keys.
    """

    hint: str | None = None
    """
    Hint/placeholder text shown when nothing is selected.
    """

    loading: bool | None = None
    """
    If ``True``, a progress indicator is shown.
    """

    async_source: str | None = None
    """
    Async data source identifier or configuration used to fetch items for this control on demand.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `dropdown` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `dropdown` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `dropdown` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `dropdown` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `dropdown` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `dropdown` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `dropdown` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `dropdown` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `dropdown` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `dropdown` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `dropdown` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `dropdown` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `dropdown` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `dropdown` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `dropdown` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `dropdown` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `dropdown` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `dropdown` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `dropdown` runtime control.
    """
