from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["TransitionEffect", "Transition"]


class TransitionEffect(Component):
    """
    Animated content switcher for stateful child transitions.
    """


    duration_ms: int | None = None
    """
    Transition duration in milliseconds.
    """

    curve: str | None = None
    """
    Animation curve name used for the transition.
    """

    transition_type: str | None = None
    """
    Transition type identifier forwarded to the runtime.
    """

    preset: str | None = None
    """
    Alias preset for ``transition_type``.
    """

    state: str | None = None
    """
    State token used to select transition branches.
    """

    mode: str | None = None
    """
    Transition mode or layout strategy.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "transition"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        duration_ms: int | None = None,
        curve: str | None = None,
        transition_type: str | None = None,
        preset: str | None = None,
        state: str | None = None,
        mode: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            duration_ms=duration_ms,
            curve=curve,
            transition_type=transition_type if transition_type is not None else preset,
            preset=preset if preset is not None else transition_type,
            state=state,
            mode=mode,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)


Transition = TransitionEffect
