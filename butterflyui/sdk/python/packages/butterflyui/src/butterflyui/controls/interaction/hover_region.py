from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["HoverRegion"]

class HoverRegion(Component):
    """
    Tracks pointer hover state over its child and emits hover events.

    Wraps the child in a ``MouseRegion`` that fires ``enter`` and
    ``exit`` events when the pointer moves in or out of the bounds,
    and a ``hover`` event on every pointer movement while inside.
    An optional ``cursor`` override changes the displayed mouse cursor
    while hovering.  When ``opaque`` is ``True`` the region absorbs
    pointer events so they do not reach widgets underneath.

    ```python
    import butterflyui as bui

    bui.HoverRegion(
        bui.Card(bui.Text("Hover for info")),
        cursor="click",
    )
    ```

    Args:
        enabled:
            If ``False``, hover detection is inactive.
        opaque:
            If ``True``, the region absorbs pointer events rather than
            passing them through.
        cursor:
            Mouse cursor to display while hovering — e.g. ``"click"``,
            ``"text"``, ``"grab"``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "hover_region"

    def __init__(
        self,
        child: Any | None = None,
        *,
        enabled: bool | None = None,
        opaque: bool | None = None,
        cursor: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            opaque=opaque,
            cursor=cursor,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
