from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl


__all__ = ["ComboBox"]

@butterfly_control('combo_box', positional_fields=('value',))
class ComboBox(SelectionControl):
    """
    Editable combo-box input with option lists and async loading hooks.

    ``ComboBox`` is the canonical merged control for both ``combo_box`` and
    legacy ``combobox`` usage. It supports typed input with selectable options,
    grouped option sections, loading state for remote queries, and debounce
    configuration for server-driven suggestion pipelines.

    Example:

    ```python
    import butterflyui as bui

    field = bui.ComboBox(
        label="Assignee",
        options=[{"label": "Ava", "value": "ava"}],
        async_source="users.search",
        debounce_ms=250,
        events=["change", "query"],
    )
    ```
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    Group descriptors for grouped option sections.
    """

    hint: str | None = None
    """
    Hint text shown when input is empty.
    """

    loading: bool | None = None
    """
    If ``True``, shows loading affordances.
    """

    async_source: str | None = None
    """
    Identifier used by your runtime for remote option lookups.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `combo_box` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `combo_box` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `combo_box` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `combo_box` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `combo_box` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `combo_box` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `combo_box` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `combo_box` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `combo_box` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `combo_box` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `combo_box` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `combo_box` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `combo_box` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `combo_box` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `combo_box` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `combo_box` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `combo_box` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `combo_box` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `combo_box` runtime control.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": list(options)})

    def set_loading(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_loading", {"value": value})
