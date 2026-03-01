from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TimeTravel"]

class TimeTravel(Component):
    """Scrub-able animation time controller that exposes a numeric
    ``value`` between ``min`` and ``max``.

    *TimeTravel* acts as a global time parameter for child animations.
    When ``playing`` is ``True`` the value auto-advances at the given
    ``speed``; otherwise it can be set manually via ``set_value()``.
    Children may read the current time value through runtime event
    payloads.

    Example::

        import butterflyui as bui

        scrub = bui.TimeTravel(
            bui.Animation(bui.Text("Driven"), opacity=0.0),
            min=0,
            max=100,
            value=0,
            speed=1.0,
            playing=True,
        )

    Args:
        min: 
            Lower bound of the time value.  Defaults to ``0``.
        max: 
            Upper bound of the time value.  Defaults to ``1``.
        value: 
            Current time value.  Must lie between *min* and
            *max*.
        step: 
            Increment step used when advancing the value.
        playing: 
            When ``True`` the value auto-advances.
        speed: 
            Playback speed multiplier.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "time_travel"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        min: float | int | None = None,
        max: float | int | None = None,
        value: float | int | None = None,
        step: float | int | None = None,
        playing: bool | None = None,
        speed: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            min=min,
            max=max,
            value=value,
            step=step,
            playing=playing,
            speed=speed,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_playing(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_playing", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
