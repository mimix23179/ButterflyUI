from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Overlay"]

class Overlay(Component):
    """
    General-purpose overlay that floats child content above the widget tree.

    The runtime renders a layer on top of the widget tree, optionally
    covering the background with a scrim. ``open`` controls visibility.
    ``dismissible`` closes the overlay when the scrim is tapped.
    ``alignment`` positions the floating content within the overlay area.
    ``scrim_color`` tints the background.

    ```python
    import butterflyui as bui

    bui.Overlay(
        bui.Text("Floating content"),
        open=True,
        alignment="center",
        scrim_color="#80000000",
        events=["close"],
    )
    ```

    Args:
        open:
            When ``True`` the overlay is visible.
        dismissible:
            When ``True`` tapping the scrim closes the overlay.
        alignment:
            Alignment of the floating content within the overlay area.
        scrim_color:
            Color of the background scrim overlay.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "overlay"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        dismissible: bool | None = None,
        alignment: Any | None = None,
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
            dismissible=dismissible,
            alignment=alignment,
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
