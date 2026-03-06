from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["NavigationRing"]


class NavigationRing(Component):
    """
    Compact ring-style navigation selector with icon-first destinations.

    Renders a rounded destination cluster for compact mode switching and
    dashboard navigation shells. Keeps selected state, emits ``select`` and
    ``change`` events, and supports runtime state mutation methods.

    Item entries accept rich metadata:
    ``id``/``value`` identity, ``label`` text, ``icon`` descriptors, optional
    ``badge`` text, and ``enabled`` boolean state.

    Shared frame/layout hints are accepted through ``props`` to control ring
    placement and clipping (alignment, margin, constraints, radius, clip).

    Example:
        ```python
        import butterflyui as bui

        bui.NavigationRing(
            items=[
                {"id": "home", "label": "Home", "icon": "home"},
                {"id": "gallery", "label": "Gallery", "icon": "image", "badge": "3"},
                {"id": "search", "label": "Search", "icon": "search"},
            ],
            selected_id="home",
            policy="selected_only",
            dense=False,
            events=["select", "change"],
        )
        ```

    Args:
        items:
            Destination mappings rendered by the ring.
        selected_id:
            Active destination ``id``.
        policy:
            Label visibility policy: ``"always"``, ``"selected_only"``, ``"never"``.
        dense:
            Enables compact spacing and icon sizing.
        events:
            Runtime event whitelist emitted by the Flutter renderer.
        props:
            Additional raw props merged after typed arguments, including layout
            hints and visual configuration.
        style:
            Optional style token map forwarded to the style pipeline.
        strict:
            When ``True``, schema validation errors are raised for unknown props.
        **kwargs:
            Extra passthrough props for advanced renderer customization.
    """


    items: list[Mapping[str, Any]] | None = None
    """
    Destination mappings rendered by the ring.
    """

    selected_id: str | None = None
    """
    Active destination ``id``.
    """

    policy: str | None = None
    """
    Label visibility policy: ``"always"``, ``"selected_only"``, ``"never"``.
    """

    dense: bool | None = None
    """
    Enables compact spacing and icon sizing.
    """

    events: list[str] | None = None
    """
    Runtime event whitelist emitted by the Flutter renderer.
    """

    control_type = "navigation_ring"

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
