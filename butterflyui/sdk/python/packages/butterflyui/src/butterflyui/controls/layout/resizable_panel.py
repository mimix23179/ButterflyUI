from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ResizablePanel"]

class ResizablePanel(Component):
    """
    A panel with a visible drag handle that the user can resize.

    The runtime renders a panel with a handle affordance along the specified
    ``axis``. Dragging the handle adjusts the panel ``size`` within the
    bounds set by ``min_size`` and ``max_size``. ``drag_handle_size`` controls
    the width or height of the handle affordance.

    ```python
    import butterflyui as bui

    bui.ResizablePanel(
        bui.Text("Panel content"),
        axis="horizontal",
        size=300,
        min_size=150,
        max_size=600,
        events=["resize"],
    )
    ```

    Args:
        axis:
            Resize axis. Values: ``"horizontal"``, ``"vertical"``.
        size:
            Initial panel size in logical pixels along the resize axis.
        min_size:
            Minimum allowed size in logical pixels.
        max_size:
            Maximum allowed size in logical pixels.
        drag_handle_size:
            Width or height of the drag handle affordance in logical pixels.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "resizable_panel"

    def __init__(
        self,
        *children: Any,
        axis: str | None = None,
        size: float | None = None,
        min_size: float | None = None,
        max_size: float | None = None,
        drag_handle_size: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            axis=axis,
            size=size,
            min_size=min_size,
            max_size=max_size,
            drag_handle_size=drag_handle_size,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_size(self, session: Any, size: float) -> dict[str, Any]:
        return self.invoke(session, "set_size", {"size": float(size)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
