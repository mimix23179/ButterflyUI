from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NavRing"]

class NavRing(Component):
    """
    Circular or ring-shaped bottom navigation bar.

    The runtime renders a compact ring-style nav bar. ``items`` supplies
    the navigation options (each with an ``id``, ``icon``, and optional
    ``label``). ``selected_id`` marks the active item. ``policy`` controls
    label visibility (e.g. ``"always"``, ``"selected_only"``). ``dense``
    reduces the bar height.

    ```python
    import butterflyui as bui

    bui.NavRing(
        items=[
            {"id": "home", "icon": "home", "label": "Home"},
            {"id": "search", "icon": "search", "label": "Search"},
        ],
        selected_id="home",
        events=["select"],
    )
    ```

    Args:
        items:
            List of navigation item specs. Each should include ``id`` and
            ``icon``.
        selected_id:
            The ``id`` of the currently active item.
        policy:
            Label display policy. Values: ``"always"``, ``"selected_only"``,
            ``"never"``.
        dense:
            Reduces bar height and item padding.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "nav_ring"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        selected_id: str | None = None,
        policy: str | None = None,
        dense: bool | None = None,
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
            policy=policy,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, selected_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"selected_id": selected_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
