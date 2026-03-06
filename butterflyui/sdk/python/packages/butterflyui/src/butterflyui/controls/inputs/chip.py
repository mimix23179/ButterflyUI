from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl


__all__ = ["Chip"]

@butterfly_control('chip', positional_fields=('label',))
class Chip(FormFieldControl):
    """
    Unified chip surface for single chips and grouped chip sets.

    ``Chip`` replaces the old ``chip_group`` API. It can represent one
    dismissible/interactive chip, or render a collection of selectable chips via
    ``options``/``items``. In grouped mode, use ``multi_select`` with
    ``values`` to support multi-selection workflows.

    ``Chip`` also forwards universal style pipeline fields through ``**kwargs``
    so color accents, transparency, and effect/motion styling remain
    consistent with Candy/Skins contracts.

    Example:

    ```python
    import butterflyui as bui

    filters = bui.Chip(
        options=[
            {"label": "Images", "value": "image"},
            {"label": "Video", "value": "video"},
        ],
        multi_select=True,
        values=["image"],
        events=["change"],
    )
    ```
    """

    dismissible: bool | None = None
    """
    If ``True``, the chip can be dismissed.
    """

    options: list[Any] | None = None
    """
    Option descriptors for grouped mode.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    values: list[Any] | None = None
    """
    Selected values for grouped multi-select mode.
    """

    multi_select: bool | None = None
    """
    Enables multi-selection when rendering grouped chips.
    """

    selected: bool | None = None
    """
    Selected state for single-chip mode.
    """

    color: Any | None = None
    """
    Color override for chip background/accent treatment.
    """

    spacing: float | None = None
    """
    Horizontal spacing between chips in grouped mode.
    """

    run_spacing: float | None = None
    """
    Vertical spacing between chip rows in wrapped layouts.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `chip` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `chip` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `chip` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `chip` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `chip` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `chip` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `chip` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `chip` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `chip` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `chip` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `chip` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `chip` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `chip` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `chip` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `chip` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `chip` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `chip` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `chip` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `chip` runtime control.
    """

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": list(values)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
