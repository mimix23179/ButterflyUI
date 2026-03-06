from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Sidebar"]

@butterfly_control('sidebar')
class Sidebar(LayoutControl):
    """
    Configurable navigation sidebar with sections, search, and selection state.

    ``Sidebar`` is the canonical replacement for legacy ``navigator``. It can
    render either a flat list (``items``) or grouped sections (``sections``),
    optionally with a searchable header and collapsible groups.

    Through ``props`` the control also supports shared placement/layout hints
    (alignment/position, margin, constraints, radius/clip behavior).

    Example:

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
    """

    sections: list[Mapping[str, Any]] | None = None
    """
    Grouped navigation sections, each containing nested ``items``.
    """

    selected_id: str | None = None
    """
    Identifier of the currently selected item, tab, route, or navigation destination.
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

    align: Any | None = None
    """
    Align value forwarded to the `sidebar` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `sidebar` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `sidebar` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `sidebar` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `sidebar` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `sidebar` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `sidebar` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `sidebar` runtime control.
    """

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
