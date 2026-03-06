from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Drawer"]


class Drawer(Component):
    """
    Standalone drawer overlay control with optional built-in navigation content.

    ``Drawer`` is backed by its own Dart control implementation (not an alias
    of ``slide_panel``). It supports both:
    - custom content mode via ``child`` / ``children``, and
    - data-driven menu mode via ``items`` or grouped ``sections``.

    The built-in menu mode includes selection, optional search, optional
    collapsible sections, and runtime events for open/close/dismiss/select.
    Drawer presentation is edge-anchored through ``side`` and can be sized
    with ``size`` (or width/height aliases passed through ``props``).

    Layout and placement props are supported through the shared runtime contract
    (for example ``margin``, ``radius``, ``clip_behavior``, ``align`` /
    ``alignment`` / ``position``, and sizing constraints).

    ```python
    import butterflyui as bui

    drawer = bui.Drawer(
        side="left",
        size=280,
        items=[
            {"id": "home", "label": "Home"},
            {"id": "settings", "label": "Settings"},
        ],
        selected_id="home",
        show_search=True,
        dismissible=True,
        events=["open", "close", "select"],
    )
    ```

    Args:
        open:
            If ``True``, the drawer is shown.
        side:
            Drawer edge: ``"left"``, ``"right"``, ``"top"``, or ``"bottom"``.
        size:
            Width for left/right drawers, or height for top/bottom drawers.
        dismissible:
            If ``True``, tapping the scrim dismisses the drawer.
        scrim_color:
            Scrim color shown behind the drawer while open.
        modal:
            Modal behavior hint for host runtimes.
        persistent:
            Persistent layout hint for host runtimes.
        items:
            Flat list of menu item descriptors for built-in menu rendering.
        sections:
            Sectioned item descriptors for grouped menu rendering.
        selected_id:
            Selected item ID when using data-driven menu content.
        show_search:
            Enables built-in search input for menu content.
        query:
            Initial search query text.
        collapsible:
            Enables collapsible sections in sectioned mode.
        events:
            Event names the Flutter runtime should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    open: bool | None = None
    """
    If ``True``, the drawer is shown.
    """

    dismissible: bool | None = None
    """
    If ``True``, tapping the scrim dismisses the drawer.
    """


    side: str | None = None
    """
    Drawer edge: ``"left"``, ``"right"``, ``"top"``, or ``"bottom"``.
    """

    size: float | None = None
    """
    Width for left/right drawers, or height for top/bottom drawers.
    """

    scrim_color: Any | None = None
    """
    Scrim color shown behind the drawer while open.
    """

    modal: bool | None = None
    """
    Modal behavior hint for host runtimes.
    """

    persistent: bool | None = None
    """
    Persistent layout hint for host runtimes.
    """

    items: list[Any] | None = None
    """
    Flat list of menu item descriptors for built-in menu rendering.
    """

    sections: list[Mapping[str, Any]] | None = None
    """
    Sectioned item descriptors for grouped menu rendering.
    """

    selected_id: str | None = None
    """
    Selected item ID when using data-driven menu content.
    """

    show_search: bool | None = None
    """
    Enables built-in search input for menu content.
    """

    query: str | None = None
    """
    Initial search query text.
    """

    collapsible: bool | None = None
    """
    Enables collapsible sections in sectioned mode.
    """

    events: list[str] | None = None
    """
    Event names the Flutter runtime should emit to Python.
    """

    control_type = "drawer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        scrim_color: Any | None = None,
        modal: bool | None = None,
        persistent: bool | None = None,
        items: list[Any] | None = None,
        sections: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        show_search: bool | None = None,
        query: str | None = None,
        collapsible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            scrim_color=scrim_color,
            modal=modal,
            persistent=persistent,
            items=items,
            sections=sections,
            selected_id=selected_id,
            show_search=show_search,
            query=query,
            collapsible=collapsible,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, open: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"open": open})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
