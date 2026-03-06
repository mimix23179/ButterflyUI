from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Chip"]


class Chip(Component):
    """Unified chip surface for single chips and grouped chip sets.
    
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


    label: str | None = None
    """
    Label text for single-chip mode.
    """

    value: Any | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
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

    dense: bool | None = None
    """
    Enables a denser layout with reduced gaps, padding, or row height.
    """

    spacing: float | None = None
    """
    Horizontal spacing between chips in grouped mode.
    """

    run_spacing: float | None = None
    """
    Vertical spacing between chip rows in wrapped layouts.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        run_spacing: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        label=label,
                        value=value,
                        options=options if options is not None else items,
                        items=items if items is not None else options,
                        values=values,
                        multi_select=multi_select,
                        selected=selected,
                        enabled=enabled,
                        dismissible=dismissible,
                        color=color,
                        dense=dense,
                        spacing=spacing,
                        run_spacing=run_spacing,
                        events=events,
                        **kwargs,
                    )
        super().__init__(
            props=merged,
            style=style,
            strict=strict,
        )

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
