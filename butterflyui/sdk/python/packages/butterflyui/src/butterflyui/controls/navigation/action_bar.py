from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ActionBar"]


class ActionBar(Component):
    """
    Horizontal command surface for global and context-sensitive actions.
    
    Supports explicit ``items`` payloads and/or child controls. Item payloads
    may include icon descriptors and optional metadata so runtime events can
    carry command context.
    
    The control also participates in shared layout props used across navigation
    and overlay surfaces, including alignment/positioning, margin, size
    constraints, radius, and clip behavior.

    Example:
    
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
    """


    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    dense: bool | None = None
    """
    Reduces item height and padding.
    """

    spacing: float | None = None
    """
    Gap between items in logical pixels.
    """

    wrap: bool | None = None
    """
    When ``True`` items wrap onto a second line when space runs out.
    """

    bgcolor: Any | None = None
    """
    Background fill color of the bar.
    """

    context: Mapping[str, Any] | None = None
    """
    Arbitrary context payload associated with this action surface.
    """

    selection: list[Any] | Mapping[str, Any] | None = None
    """
    Selection payload (IDs or descriptors) used by contextual actions.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
        context: Mapping[str, Any] | None = None,
        selection: list[Any] | Mapping[str, Any] | None = None,
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
            context=context,
            selection=selection,
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
