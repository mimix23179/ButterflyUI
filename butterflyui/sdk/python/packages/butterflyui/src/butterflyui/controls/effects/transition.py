from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Transition"]

class Transition(Component):
    """Animated content switcher that crossfades or slides between
    child states using ``AnimatedSwitcher``.

    The Flutter runtime wraps the child in an ``AnimatedSwitcher``
    whose ``transitionBuilder`` is selected by *transition_type*:
    ``"fade"`` (default), ``"scale"``, or ``"slide"`` (slide +
    fade).  The *state* / *value* parameter acts as the switcher key:
    changing it triggers the transition.

    Example::

        import butterflyui as bui

        trans = bui.Transition(
            bui.Text("Page A"),
            transition_type="fade",
            duration_ms=300,
            state="page_a",
        )

    Args:
        duration_ms: 
            Transition duration in milliseconds.  Defaults to
            ``220``; clamped to ``1 – 600 000``.
        curve: 
            Named easing curve (e.g. ``"ease_out_cubic"``).
            Defaults to ``ease_out_cubic``.
        transition_type: 
            Transition style — ``"fade"`` (default),
            ``"scale"``, or ``"slide"`` (combined slide + fade).
        preset: 
            Alias for *transition_type*.
        state: 
            Key string that identifies the current content.  When
            this value changes the ``AnimatedSwitcher`` plays the
            transition.
        mode: 
            Reserved — switcher layout mode.
        enabled: 
            When ``False`` the child renders without any
            transition animation.
        events:
            List of event names the Flutter runtime should emit to Python.
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
