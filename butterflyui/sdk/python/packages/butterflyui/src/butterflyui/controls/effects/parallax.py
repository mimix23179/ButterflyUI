from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Parallax"]

class Parallax(Component):
    """Mouse-tracked parallax offset effect that shifts the child in
    response to pointer position.

    The Flutter runtime wraps the child in a ``MouseRegion`` and
    computes a normalised − 1…+1 offset from the pointer position
    relative to the widget centre.  An ``AnimatedContainer`` smoothly
    translates the child by up to ``max_offset`` logical pixels in
    each direction.  On pointer exit the offset resets to zero (unless
    ``reset_on_exit`` is ``False``).

    Example::

        import butterflyui as bui

        parallax = bui.Parallax(
            bui.Image(src="hero.png"),
            max_offset=20,
            reset_on_exit=True,
        )

    Args:
        max_offset: 
            Maximum translation in logical pixels along each
            axis.  Defaults to ``14``; clamped to ``0 – 200``.
        reset_on_exit: 
            When ``True`` (default) the offset smoothly
            resets to zero when the pointer leaves the widget.
        depths: 
            Reserved — per-layer depth factors for multi-layer
            parallax.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "parallax"

    def __init__(
        self,
        child: Any | None = None,
        *,
        max_offset: float | None = None,
        reset_on_exit: bool | None = None,
        depths: list[float] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            max_offset=max_offset,
            reset_on_exit=reset_on_exit,
            depths=depths,
            events=events,
            **kwargs,
        )
        super().__init__(child=child, props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})
