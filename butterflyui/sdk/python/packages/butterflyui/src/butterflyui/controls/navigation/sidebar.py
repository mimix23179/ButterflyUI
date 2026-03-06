from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Sidebar"]


class Sidebar(Component):
    """Configurable navigation sidebar with sections, search, and selection state.
    
    ``Sidebar`` is the canonical replacement for legacy ``navigator``. It can
    render either a flat list (``items``) or grouped sections (``sections``),
    optionally with a searchable header and collapsible groups.
    
    Through ``props`` the control also supports shared placement/layout hints
    (alignment/position, margin, constraints, radius/clip behavior).
    
    ```python
    import butterflyui as bui
    
    nav = bui.Sidebar(
        title="Workspace",
        items=[
            {"id": "home", "label": "Home"},
            {"id": "settings", "label": "Settings"},
        ],
        selected_id="home",
        show_search=True,
        events=["select", "search"],
    )
    ```
    
    Args:
        sections:
            Grouped navigation sections, each containing nested ``items``.
        items:
            Flat list of navigation item descriptors.
        selected_id:
            Identifier of the currently selected item, tab, route, or navigation destination.
        title:
            Primary heading text rendered by the control.
        show_search:
            Enables a search input at the top of the sidebar.
        query:
            Current query string used to filter, search, or narrow the control's content.
        collapsible:
            Enables collapsible section behavior.
        dense:
            Enables a denser layout with reduced gaps, padding, or row height.
        emit_on_search_change:
            Emits search events while typing.
        search_debounce_ms:
            Debounce window for incremental search events.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    sections: list[Mapping[str, Any]] | None = None
    """
    Grouped navigation sections, each containing nested ``items``.
    """

    items: list[Any] | None = None
    """
    Flat list of navigation item descriptors.
    """

    selected_id: str | None = None
    """
    Identifier of the currently selected item, tab, route, or navigation destination.
    """

    title: str | None = None
    """
    Primary heading text rendered by the control.
    """

    show_search: bool | None = None
    """
    Enables a search input at the top of the sidebar.
    """

    query: str | None = None
    """
    Current query string used to filter, search, or narrow the control's content.
    """

    collapsible: bool | None = None
    """
    Enables collapsible section behavior.
    """

    dense: bool | None = None
    """
    Enables a denser layout with reduced gaps, padding, or row height.
    """

    emit_on_search_change: bool | None = None
    """
    Emits search events while typing.
    """

    search_debounce_ms: int | None = None
    """
    Debounce window for incremental search events.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "sidebar"

    def __init__(
        self,
        *,
        sections: list[Mapping[str, Any]] | None = None,
        items: list[Any] | None = None,
        selected_id: str | None = None,
        title: str | None = None,
        show_search: bool | None = None,
        query: str | None = None,
        collapsible: bool | None = None,
        dense: bool | None = None,
        emit_on_search_change: bool | None = None,
        search_debounce_ms: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            sections=sections,
            items=items,
            selected_id=selected_id,
            title=title,
            show_search=show_search,
            query=query,
            collapsible=collapsible,
            dense=dense,
            emit_on_search_change=emit_on_search_change,
            search_debounce_ms=search_debounce_ms,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(
        self,
        session: Any,
        event: str,
        payload: Mapping[str, Any] | None = None,
    ) -> dict[str, Any]:
        return self.invoke(
            session,
            "emit",
            {"event": event, "payload": dict(payload or {})},
        )
