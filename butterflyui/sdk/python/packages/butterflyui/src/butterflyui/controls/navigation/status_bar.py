from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["StatusBar"]

class StatusBar(Component):
    """Horizontal status bar displayed at the bottom of an application window.
    
    The runtime renders a fixed-height bar at the bottom edge. ``items``
    supply labelled status segments (left or right aligned). ``text`` sets
    a single plain-text message when a full item list is not needed.
    ``dense`` reduces bar height. Runtime invokes support item/text updates
    and arbitrary event emission.
    
    Shared layout hints are accepted through ``props`` for dock/placement
    control (alignment/position, margin, width/height constraints, radius/clip).
    
    ```python
    import butterflyui as bui
    
    bui.StatusBar(
        items=[
            {"id": "branch", "label": "main", "icon": "branch"},
            {"id": "errors", "label": "0 errors", "align": "right"},
        ],
    )
    ```
    
    Args:
        items:
            Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
        text:
            Simple plain-text status message (used instead of ``items``).
        dense:
            Reduces bar height and item padding.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
    """


    items: list[Mapping[str, Any]] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    text: str | None = None
    """
    Simple plain-text status message (used instead of ``items``).
    """

    dense: bool | None = None
    """
    Reduces bar height and item padding.
    """

    control_type = "status_bar"

    def __init__(
        self,
        *,
        items: list[Mapping[str, Any]] | None = None,
        text: str | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            items=items,
            text=text,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_items(self, session: Any, items: list[Mapping[str, Any]]) -> dict[str, Any]:
        return self.invoke(session, "set_items", {"items": [dict(item) for item in items]})

    def set_text(self, session: Any, text: str) -> dict[str, Any]:
        return self.invoke(session, "set_text", {"text": text})

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
