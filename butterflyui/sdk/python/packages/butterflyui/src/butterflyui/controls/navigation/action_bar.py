from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ActionBar"]

class ActionBar(Component):
    """
    Horizontal toolbar displaying a list of action buttons or child widgets.

    The runtime renders a row of action items. ``items`` supplies inline item
    specs; positional children may also be passed. ``dense`` reduces button
    height; ``spacing`` controls the gap between items; ``wrap`` enables
    multi-line wrapping when items overflow; ``alignment`` sets the horizontal
    distribution of items; ``bgcolor`` paints the bar background.

    ```python
    import butterflyui as bui

    bui.ActionBar(
        items=[
            {"id": "new", "icon": "add", "tooltip": "New"},
            {"id": "save", "icon": "save", "tooltip": "Save"},
        ],
        spacing=4,
        events=["action"],
    )
    ```

    Args:
        items:
            List of action item spec mappings to display in the bar.
        dense:
            Reduces item height and padding.
        spacing:
            Gap between items in logical pixels.
        wrap:
            When ``True`` items wrap onto a second line when space runs out.
        alignment:
            Horizontal alignment of items within the bar.
        bgcolor:
            Background fill color of the bar.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "action_bar"

    def __init__(
        self,
        *children: Any,
        items: list[Mapping[str, Any]] | None = None,
        dense: bool | None = None,
        spacing: float | None = None,
        wrap: bool | None = None,
        alignment: str | None = None,
        bgcolor: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            dense=dense,
            spacing=spacing,
            wrap=wrap,
            alignment=alignment,
            bgcolor=bgcolor,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": items})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
