from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["SlidePanel"]

class SlidePanel(Component):
    """
    Animated panel that slides in from any screen edge as an overlay.

    The runtime renders a panel that animates in from the edge specified by
    ``side``. ``open`` controls visibility. ``size`` fixes the panel width
    (left/right) or height (top/bottom). ``dismissible`` allows closing
    by tapping the scrim. ``scrim_color`` tints the dimmed background.

    ```python
    import butterflyui as bui

    bui.SlidePanel(
        bui.Text("Panel content"),
        side="right",
        size=320,
        open=False,
        dismissible=True,
        events=["open", "close"],
    )
    ```

    Args:
        open:
            When ``True`` the panel is visible.
        side:
            Edge from which the panel slides. Values: ``"left"``,
            ``"right"``, ``"top"``, ``"bottom"``.
        size:
            Panel width (left/right) or height (top/bottom) in logical
            pixels.
        dismissible:
            When ``True`` tapping the scrim closes the panel.
        scrim_color:
            Color of the background scrim overlay.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "slide_panel"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        side: str | None = None,
        size: float | None = None,
        dismissible: bool | None = None,
        scrim_color: Any | None = None,
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
            scrim_color=scrim_color,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
