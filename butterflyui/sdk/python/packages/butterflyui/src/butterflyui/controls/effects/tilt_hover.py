from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TiltHover"]

class TiltHover(Component):
    """3-D perspective tilt that follows the pointer position on hover.

    The Flutter runtime tracks the mouse via a ``MouseRegion``,
    normalises its position to − 1…+1 and applies ``Matrix4`` rotations
    (``rotateX`` / ``rotateY``) with a perspective entry to an
    ``AnimatedContainer``.  The tilt resets smoothly to zero when the
    pointer exits (unless ``reset_on_exit`` is ``False``).  Each hover
    event is optionally forwarded as a runtime ``"hover"`` event.

    Example::

        import butterflyui as bui

        card = bui.TiltHover(
            bui.Container(width=200, height=140),
            max_tilt=12,
            perspective=0.001,
            scale=1.02,
        )

    Args:
        max_tilt: 
            Maximum rotation angle in **degrees** along each
            axis.  Defaults to ``10``.
        perspective: 
            ``Matrix4`` perspective depth entry (row 3,
            col 2).  Defaults to ``0.0012``.
        reset_on_exit: 
            When ``True`` (default) the tilt smoothly
            resets when the pointer leaves.
        scale: 
            Uniform scale applied while hovering.  Defaults to
            ``1.0`` (no change).
        enabled: 
            When ``False`` the tilt effect is disabled and the
            child renders flat.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "tilt_hover"

    def __init__(
        self,
        child: Any | None = None,
        *,
        max_tilt: float | None = None,
        perspective: float | None = None,
        reset_on_exit: bool | None = None,
        scale: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            max_tilt=max_tilt,
            perspective=perspective,
            reset_on_exit=reset_on_exit,
            scale=scale,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
