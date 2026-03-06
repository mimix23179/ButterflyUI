from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["SlidePanel"]


class SlidePanel(Component):
    """
    Edge-anchored panel overlay for drawers, side panels, and utility trays.
    
    ``SlidePanel`` is the dedicated side-panel primitive. It can slide from
    any edge and accepts sizing aliases (``width`` / ``height``) in addition
    to ``size``. The runtime keeps open/closed state, supports invoke mutation,
    and emits ``open``, ``close``, ``dismiss``, ``change``, and ``state``.
    
    Extended panel-placement props are accepted through ``props`` such as
    ``margin`` / ``panel_margin``, ``radius``, ``clip_behavior``, and
    transition tuning fields.

    Example:
    
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
    """


    open: bool | None = None
    """
    When ``True`` the panel is visible.
    """

    dismissible: bool | None = None
    """
    When ``True`` tapping the scrim closes the panel.
    """


    side: str | None = None
    """
    Edge from which the panel slides. Values: ``"left"``,
    ``"right"``, ``"top"``, ``"bottom"``.
    """

    position: str | None = None
    """
    Backward-compatible alias for ``side``. When both fields are provided, ``side`` takes precedence and this alias is kept only for compatibility.
    """

    size: float | None = None
    """
    Panel width (left/right) or height (top/bottom) in logical
    pixels.
    """

    scrim_color: Any | None = None
    """
    Color of the background scrim overlay.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "slide_panel"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        open: bool | None = None,
        side: str | None = None,
        position: str | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
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
            side=side if side is not None else position,
            position=position if position is not None else side,
            size=size if size is not None else (width if width is not None else height),
            width=width if width is not None else size,
            height=height if height is not None else size,
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

    def set_props(self, session: Any, **props: Any) -> dict[str, Any]:
        return self.invoke(session, "set_props", {"props": props})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

    def trigger(self, session: Any, event: str = "change", **payload: Any) -> dict[str, Any]:
        return self.emit(session, event, payload)
