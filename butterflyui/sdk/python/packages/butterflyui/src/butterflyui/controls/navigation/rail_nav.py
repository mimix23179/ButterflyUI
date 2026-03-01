from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RailNav"]

class RailNav(Component):
    """
    Vertical navigation rail with icon-and-label destination items.

    Maps to Flutter's ``NavigationRail``. ``items`` is a list of
    destination specs with ``id``, ``icon``, and optional ``label``.
    ``selected_id`` highlights the active destination. ``extended`` expands
    the rail to show labels beside icons. ``dense`` reduces icon padding.

    ```python
    import butterflyui as bui

    bui.RailNav(
        items=[
            {"id": "inbox", "icon": "inbox", "label": "Inbox"},
            {"id": "sent", "icon": "send", "label": "Sent"},
        ],
        selected_id="inbox",
        extended=True,
        events=["select"],
    )
    ```

    Args:
        items:
            List of destination spec mappings. Each should include ``id``
            and ``icon``.
        selected_id:
            The ``id`` of the currently active destination.
        dense:
            Reduces destination icon size and padding.
        extended:
            When ``True`` the rail is expanded to show labels beside icons.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "rail_nav"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        dense: bool | None = None,
        extended: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=[dict(item) for item in (items or [])],
            selected_id=selected_id,
            dense=dense,
            extended=extended,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
