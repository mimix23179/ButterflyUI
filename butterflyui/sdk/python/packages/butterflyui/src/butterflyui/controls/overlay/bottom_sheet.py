from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["BottomSheet"]

class BottomSheet(Component):
    """
    Modal bottom sheet surface with configurable panel alignment and sizing.

    The runtime renders an overlay sheet that can be opened/closed via
    ``set_open`` and updated via ``set_props``. It emits ``open``, ``close``,
    ``dismiss``, ``change``, and ``state`` events.

    In addition to ``height``/``max_height`` and scrim behavior, this control
    accepts extended panel-placement props through ``props``:
    ``alignment``/``align``/``panel_alignment``, ``margin``/``panel_margin``,
    ``width``/``panel_width``, and panel width constraints.

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
        props:
            Additional runtime props including panel alignment, panel margins,
            clip behavior, radius, and sizing constraints.
    """


    open: bool | None = None
    """
    When ``True`` the bottom sheet is visible.
    """

    dismissible: bool | None = None
    """
    When ``True`` tapping the scrim closes the sheet.
    """


    scrim_color: Any | None = None
    """
    Color of the background scrim overlay.
    """

    events: list[str] | None = None
    """
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

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
