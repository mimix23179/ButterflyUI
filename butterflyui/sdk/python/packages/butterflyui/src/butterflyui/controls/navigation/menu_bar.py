from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MenuBar"]

class MenuBar(Component):
    """
    Application-level horizontal menu bar with dropdown menu groups.

    ``MenuBar`` accepts ``menus`` or ``items`` payloads. Each top-level menu
    can include nested actions, separators, shortcuts, icons, and custom
    payload metadata. Runtime emits ``open``, ``dismiss``, ``select``, and
    ``change`` events as users interact with menu groups.

    The control also supports shared layout/placement hints through ``props``
    (alignment, margin, size constraints, radius, clip behavior).

    ```python
    import butterflyui as bui

    bui.MenuBar(
        menus=[
            {
                "id": "file",
                "label": "File",
                "items": [
                    {"id": "new", "label": "New", "shortcut": "Ctrl+N"},
                    {"id": "open", "label": "Open"},
                    {"separator": True},
                    {"id": "quit", "label": "Quit", "variant": "danger"},
                ],
            },
            {
                "id": "edit",
                "label": "Edit",
                "items": [{"id": "undo", "label": "Undo", "shortcut": "Ctrl+Z"}],
            },
        ],
        events=["open", "select", "change"],
    )
    ```

    Args:
        menus:
            List of top-level menu spec mappings.
        items:
            Alias of ``menus`` when constructing from generic payloads.
        dense:
            Reduces bar height and menu item padding.
        height:
            Explicit bar height in logical pixels.
        events:
            Optional runtime event whitelist.
        props:
            Raw prop overrides including menu styling and layout hints
            (alignment/position, margin, sizing constraints, radius/clip).
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
        **kwargs:
            Additional runtime props passed through to Flutter.
    """


    menus: list[Mapping[str, Any]] | None = None
    """
    List of top-level menu spec mappings.
    """

    items: list[Any] | None = None
    """
    Alias of ``menus`` when constructing from generic payloads.
    """

    dense: bool | None = None
    """
    Reduces bar height and menu item padding.
    """

    events: list[str] | None = None
    """
    Optional runtime event whitelist.
    """

    control_type = "menu_bar"

    def __init__(
        self,
        *children: Any,
        menus: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        dense: bool | None = None,
        height: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            menus=menus,
            items=items,
            dense=dense,
            height=height,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_menus(self, session: Any, menus: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_menus",
            {"menus": [dict(menu) for menu in menus]},
        )

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(
            session,
            "set_items",
            {"items": [dict(item) for item in items]},
        )

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
