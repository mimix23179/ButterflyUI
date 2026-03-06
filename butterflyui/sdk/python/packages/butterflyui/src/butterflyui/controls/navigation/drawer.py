from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl

__all__ = ["Drawer"]

@butterfly_control('drawer')
class Drawer(LayoutControl):
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

    Example:

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

    modal: bool | None = None
    """
    Modal behavior hint for host runtimes.
    """

    persistent: bool | None = None
    """
    Persistent layout hint for host runtimes.
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
    Current query string used to filter, search, or narrow the control's content.
    """

    collapsible: bool | None = None
    """
    Enables collapsible sections in sectioned mode.
    """

    selected: Any | None = None
    """
    Selected value forwarded to the `drawer` runtime control.
    """

    value: Any | None = None
    """
    Current value held by the control.
    """

    search_placeholder: Any | None = None
    """
    Search placeholder value forwarded to the `drawer` runtime control.
    """

    emit_on_search_change: Any | None = None
    """
    Emit on search change value forwarded to the `drawer` runtime control.
    """

    search_debounce_ms: Any | None = None
    """
    Search debounce ms value forwarded to the `drawer` runtime control.
    """

    dense: Any | None = None
    """
    Whether the runtime should use a more compact visual density.
    """

    align: Any | None = None
    """
    Align value forwarded to the `drawer` runtime control.
    """

    position: Any | None = None
    """
    Position value forwarded to the `drawer` runtime control.
    """

    panel_margin: Any | None = None
    """
    Panel margin value forwarded to the `drawer` runtime control.
    """

    panel_alignment: Any | None = None
    """
    Panel alignment value forwarded to the `drawer` runtime control.
    """

    panel_width: Any | None = None
    """
    Panel width value forwarded to the `drawer` runtime control.
    """

    panel_min_width: Any | None = None
    """
    Panel min width value forwarded to the `drawer` runtime control.
    """

    panel_max_width: Any | None = None
    """
    Panel max width value forwarded to the `drawer` runtime control.
    """

    offset: Any | None = None
    """
    Offset applied by the runtime when positioning this control.
    """

    translate: Any | None = None
    """
    Translate value forwarded to the `drawer` runtime control.
    """

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
