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

    ``Chip`` also accepts shared visual props through ``**kwargs`` so color
    accents, transparency, motion, and effect settings can still be forwarded
    to the runtime.

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

    spacing: float | None = None
    """
    Horizontal spacing between chips in grouped mode.
    """

    run_spacing: float | None = None
    """
    Vertical spacing between chip rows in wrapped layouts.
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
