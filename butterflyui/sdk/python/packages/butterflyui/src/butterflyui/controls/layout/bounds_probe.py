from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BoundsProbe"]

class BoundsProbe(Component):
    """
    Transparent wrapper that measures and reports the child's rendered bounds.

    The runtime wraps its child unchanged but can emit layout-bounds events back
    to Python. Use ``emit_initial`` to receive a measurement on the first
    paint, ``emit_on_change`` to be notified on resize, and ``debounce_ms`` to
    throttle rapid update events.

    ```python
    import butterflyui as bui

    bui.BoundsProbe(
        bui.Text("Measure me"),
        emit_initial=True,
        emit_on_change=True,
        debounce_ms=100,
        events=["bounds"],
    )
    ```

    Args:
        enabled:
            When ``False`` the probe is disabled and no bounds events are emitted.
        emit_initial:
            When ``True`` fires a bounds event immediately after the first layout.
        emit_on_change:
            When ``True`` fires a bounds event whenever the child resizes.
        debounce_ms:
            Milliseconds to debounce rapid resize events.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "bounds_probe"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        enabled: bool | None = None,
        emit_initial: bool | None = None,
        emit_on_change: bool | None = None,
        debounce_ms: int | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            enabled=enabled,
            emit_initial=emit_initial,
            emit_on_change=emit_on_change,
            debounce_ms=debounce_ms,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def get_bounds(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_bounds", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
