from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Overlay"]


class Overlay(Component):
    """
    General-purpose overlay and overlay-stack host.
    
    ``Overlay`` now also absorbs legacy ``overlay_host`` capabilities. You can
    render a single floating child (traditional overlay behavior) or provide a
    ``base`` + ``overlays`` stack and select active layers.
    
    Like other core controls, ``Overlay`` forwards universal styling props
    through ``**kwargs`` so icon/color/transparency and motion/effects
    pipelines can be applied consistently.
    
    Example:
    
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
    """


    open: bool | None = None
    """
    When ``True`` the overlay is visible.
    """

    dismissible: bool | None = None
    """
    When ``True`` tapping the scrim closes the overlay.
    """


    scrim_color: Any | None = None
    """
    Color of the background scrim overlay.
    """

    base: Any | None = None
    """
    Base style map applied in the idle state before any interactive or disabled overrides are merged.
    """

    overlays: list[Any] | None = None
    """
    Overlay layer controls composed above ``base``.
    """

    active_overlay: str | list[str] | tuple[str, ...] | None = None
    """
    Active overlay ID or list of active IDs.
    """

    active_id: str | None = None
    """
    Backward-compatible alias for ``a single active overlay ID``. When both fields are provided, ``a single active overlay ID`` takes precedence and this alias is kept only for compatibility.
    """

    active_index: int | None = None
    """
    Zero-based index of the currently active item, overlay, or page within the control.
    """

    show_all_overlays: bool | None = None
    """
    If ``True``, all overlays are visible simultaneously.
    """

    show_default_overlay: bool | None = None
    """
    If ``True``, first overlay is shown by default.
    """

    max_visible_overlays: int | None = None
    """
    Maximum number of overlays visible at once.
    """

    transition: Mapping[str, Any] | None = None
    """
    Overlay transition descriptor mapping.
    """

    transition_type: str | None = None
    """
    Named transition preset for overlay changes.
    """

    transition_ms: int | None = None
    """
    Transition duration in milliseconds.
    """

    clip: bool | None = None
    """
    If ``True``, clip overlay layers to host bounds.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
        base: Any | None = None,
        overlays: list[Any] | None = None,
        active_overlay: str | list[str] | tuple[str, ...] | None = None,
        active_id: str | None = None,
        active_index: int | None = None,
        show_all_overlays: bool | None = None,
        show_default_overlay: bool | None = None,
        max_visible_overlays: int | None = None,
        transition: Mapping[str, Any] | None = None,
        transition_type: str | None = None,
        transition_ms: int | None = None,
        clip: bool | None = None,
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
            base=base,
            overlays=overlays,
            active_overlay=active_overlay,
            active_id=active_id,
            active_index=active_index,
            show_all_overlays=show_all_overlays,
            show_default_overlay=show_default_overlay,
            max_visible_overlays=max_visible_overlays,
            transition=transition,
            transition_type=transition_type,
            transition_ms=transition_ms,
            clip=clip,
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
