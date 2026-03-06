from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["RailNavigation"]


class RailNavigation(Component):
    """Vertical navigation rail with selectable destinations and icon states.
    
    ``RailNavigation`` is suitable for desktop/tablet shell layouts where
    major sections are represented as left or right rail destinations.
    Supports dense mode, extended mode, and runtime selection updates.
    
    Item mappings may define ``icon`` and ``selected_icon`` descriptors along
    with ``id``, ``label``, and ``enabled`` state.
    
    Shared frame/layout hints are accepted through ``props`` to place rails
    in custom shells (alignment, margin, sizing constraints, radius/clip).
    
    Example:
        ```python
        import butterflyui as bui
    
        bui.RailNavigation(
            items=[
                {"id": "inbox", "label": "Inbox", "icon": "inbox"},
                {"id": "sent", "label": "Sent", "icon": "send"},
                {"id": "archive", "label": "Archive", "icon": "archive"},
            ],
            selected_id="inbox",
            extended=True,
            events=["select", "change"],
        )
        ```
    
    Args:
        items:
            Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
        selected_id:
            Identifier of the currently selected item, tab, route, or navigation destination.
        dense:
            Enables compact spacing and icon sizing.
        extended:
            Expands rail width and displays labels inline.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
        **kwargs:
            Extra passthrough props for advanced renderer customization.
    """


    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    selected_id: str | None = None
    """
    Identifier of the currently selected item, tab, route, or navigation destination.
    """

    dense: bool | None = None
    """
    Enables compact spacing and icon sizing.
    """

    extended: bool | None = None
    """
    Expands rail width and displays labels inline.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "rail_navigation"

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

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
