from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .slide_panel import SlidePanel

__all__ = ["SidePanel"]

class SidePanel(SlidePanel):
    """
    Persistent or overlay side panel that slides from a screen edge.

    A named specialization of ``SlidePanel`` with side-panel semantics.
    Inherits all ``SlidePanel`` properties. Commonly used for settings
    drawers, detail panels, and secondary navigation layers.

    ```python
    import butterflyui as bui

    bui.SidePanel(
        bui.Text("Side panel content"),
        side="right",
        size=320,
        open=False,
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

    control_type = "side_panel"

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
        super().__init__(
            child=child,
            *children,
            open=open,
            side=side,
            size=size,
            dismissible=dismissible,
            scrim_color=scrim_color,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
