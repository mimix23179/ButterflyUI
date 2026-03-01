from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BottomSheet"]

class BottomSheet(Component):
    """Bottom sheet that slides up from the bottom of the screen.

    Renders a persistent or modal panel anchored to the bottom edge of the
    Flutter widget tree, used for supplementary content or quick actions.

    Example:
        ```python
        sheet = BottomSheet(open=True, dismissible=True, height=300)
        ```

    Args:
        open: Whether the bottom sheet is visible.
        dismissible: Whether tapping the scrim closes the sheet.
        scrim_color: Color of the background scrim overlay.
        height: Initial height of the sheet in logical pixels.
        max_height: Maximum height the sheet may expand to.
        events: Flutter client events to subscribe to.
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
