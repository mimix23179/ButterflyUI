from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Drawer"]

class Drawer(Component):
    """
    Slide-in panel drawer that overlays the main content from a screen edge.

    The runtime renders a modal or persistent side panel. ``open`` controls
    visibility; ``side`` sets which edge the drawer slides from
    (``"left"``, ``"right"``, ``"top"``, ``"bottom"``). ``size`` fixes the
    panel width or height. ``dismissible`` allows closing by tapping outside.

    ```python
    import butterflyui as bui

    bui.Drawer(
        bui.Text("Navigation content"),
        side="left",
        size=280,
        dismissible=True,
        events=["open", "close"],
    )
    ```

    Args:
        open:
            When ``True`` the drawer is visible.
        side:
            Edge from which the drawer slides. Values: ``"left"``,
            ``"right"``, ``"top"``, ``"bottom"``.
        size:
            Width (for left/right) or height (for top/bottom) in logical pixels.
        dismissible:
            When ``True`` tapping outside the drawer closes it.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "drawer"

    def __init__(
        self,
        child: Any | None = None,
        *,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

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
