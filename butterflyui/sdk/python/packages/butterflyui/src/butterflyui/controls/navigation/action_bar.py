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
        context:
            Arbitrary context payload associated with this action surface.
        selection:
            Selection payload (IDs or descriptors) used by contextual actions.
        events:
            List of event names the Flutter runtime should emit to Python.
        align / alignment / position:
            Placement hints for wrapper alignment in parent layouts.
        margin:
            Outer spacing around the action bar.
        width / height / min_width / max_width / min_height / max_height:
            Optional sizing and constraint hints.
        radius:
            Outer clipping/shape radius for the action bar shell.
        clip_behavior:
            Clip strategy for rounded shells and overflow.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
        **kwargs:
            Additional runtime props forwarded to the shared style pipeline.
    """


    items: list[Mapping[str, Any]] | None = None
    """
    List of action item spec mappings to display in the bar.
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
