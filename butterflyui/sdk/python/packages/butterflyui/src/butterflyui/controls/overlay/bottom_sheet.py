from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BottomSheet"]

class BottomSheet(Component):
    """
    Modal bottom sheet that slides up from the bottom edge of the screen.

    The runtime renders a Flutter ``BottomSheet``-style overlay. ``open``
    shows or hides the sheet. ``dismissible`` allows the user to close it
    by tapping the scrim. ``scrim_color`` tints the background overlay.
    ``height`` fixes the sheet height; ``max_height`` caps it when content
    is dynamic.

    ```python
    import butterflyui as bui

    bui.BottomSheet(
        bui.Text("Sheet content"),
        open=True,
        height=300,
        dismissible=True,
        events=["close"],
    )
    ```

    Args:
        open:
            When ``True`` the bottom sheet is visible.
        dismissible:
            When ``True`` tapping the scrim closes the sheet.
        scrim_color:
            Color of the background scrim overlay.
        height:
            Fixed sheet height in logical pixels.
        max_height:
            Maximum sheet height when content determines its size.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "bottom_sheet"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        dismissible: bool | None = None,
        scrim_color: Any | None = None,
        height: float | None = None,
        max_height: float | None = None,
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
            scrim_color=scrim_color,
            height=height,
            max_height=max_height,
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

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
