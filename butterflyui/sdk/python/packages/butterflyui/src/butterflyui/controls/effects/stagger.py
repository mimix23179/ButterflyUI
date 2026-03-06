from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Stagger"]

class Stagger(Component):
    """
    Staggered fade-in animation that reveals children one after
    another with cascading delays.
    
    The Flutter runtime wraps each child in a ``FadeTransition`` +
    ``Transform.translate`` controlled by a single
    ``AnimationController``.  Each child's animation starts after a
    configurable per-item delay (``stagger_ms``), producing a
    sequential entrance effect.
    
    Example:

    ```python
    import butterflyui as bui

    stagger = bui.Stagger(
        bui.Text("Line 1"),
        bui.Text("Line 2"),
        bui.Text("Line 3"),
        stagger_ms=60,
        duration_ms=500,
        direction="vertical",
    )
    ```
    """


    stagger_ms: int | None = None
    """
    Per-item delay in milliseconds between successive
    child animations (``0`` – ``4000``).  Defaults to ``40``.
    """

    stagger: int | None = None
    """
    Backward-compatible alias for ``*stagger_ms*``. When both fields are provided, ``*stagger_ms*`` takes precedence and this alias is kept only for compatibility.
    """

    direction: str | None = None
    """
    Layout and slide direction — ``"vertical"``
    (default, slides from below) or ``"horizontal"`` (slides
    from the right).
    """

    play: bool | None = None
    """
    When ``True`` (default) the stagger starts on mount;
    set to ``False`` to defer.
    """

    duration_ms: int | None = None
    """
    Total animation controller duration in
    milliseconds.  Defaults to ``420``; clamped to
    ``50 – 60 000``.
    """

    curve: str | None = None
    """
    Named easing curve (e.g. ``"ease_out_cubic"``).
    Defaults to ``ease_out_cubic``.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "stagger"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        stagger_ms: int | None = None,
        stagger: int | None = None,
        direction: str | None = None,
        play: bool | None = None,
        duration_ms: int | None = None,
        curve: str | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            stagger_ms=stagger_ms,
            stagger=stagger,
            direction=direction,
            play=play,
            duration_ms=duration_ms,
            curve=curve,
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)

    def set_play(self, session: Any, play: bool) -> dict[str, Any]:
        return self.invoke(session, "set_play", {"play": play})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
