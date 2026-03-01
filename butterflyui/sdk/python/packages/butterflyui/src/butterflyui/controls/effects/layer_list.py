from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["LayerList"]

class LayerList(Component):
    """Stacked layer compositor that renders children as
    ``Positioned.fill`` entries inside a ``Stack``.

    The Flutter runtime merges explicit ``layers`` definitions with
    positional children, then filters them by visibility and an
    optional ``active_layer`` / ``active_id``.  When *mode* is
    ``"active"`` only the layer whose ``id`` matches the active value
    is shown.

    Example::

        import butterflyui as bui

        stack = bui.LayerList(
            bui.Image(src="bg.png"),
            bui.Text("Overlay"),
            mode="active",
            active_layer="overlay",
        )

    Args:
        layers: 
            Explicit layer definition list.  Each mapping may
            contain ``id``, ``visible``, and nested ``props``.
        active_layer: 
            ID of the currently active layer.  Layers whose
            ``id`` does not match are hidden when *mode* is
            ``"active"``.
        active_id: 
            Alias for *active_layer*.
        max_visible_overlays: 
            Reserved limit on how many overlay
            layers remain visible simultaneously.
        mode: 
            Filtering mode — ``"active"`` restricts rendering to
            the layer matching *active_layer*; any other value (or
            omitted) shows all visible layers.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "layer_list"

    def __init__(
        self,
        *children: Any,
        layers: list[Mapping[str, Any]] | None = None,
        active_layer: str | None = None,
        active_id: str | None = None,
        max_visible_overlays: int | None = None,
        mode: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            layers=[dict(layer) for layer in (layers or [])],
            active_layer=active_layer if active_layer is not None else active_id,
            active_id=active_id if active_id is not None else active_layer,
            max_visible_overlays=max_visible_overlays,
            mode=mode,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_active(self, session: Any, layer_id: str) -> dict[str, Any]:
        return self.invoke(session, "set_active", {"active_id": layer_id})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
