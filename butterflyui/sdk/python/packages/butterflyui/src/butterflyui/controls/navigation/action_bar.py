from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ActionBar"]


class ActionBar(Component):
    """
    Horizontal action toolbar for global and context-sensitive commands.

    ``ActionBar`` is the canonical replacement for legacy
    ``context_action_bar`` and supports both explicit ``items`` payloads and
    child controls. It can optionally carry selection/context metadata so the
    runtime can emit richer command events.

    Item payloads may include icon descriptors (for example ``{"icon":
    "save"}``) and color/transparency styling fields when supported by runtime
    themes.

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
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
        **kwargs:
            Additional runtime props forwarded to the shared style pipeline.
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
