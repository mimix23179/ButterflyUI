from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["RatingDisplay"]

class RatingDisplay(Component):
    """Star-based rating display.

    Renders a horizontal row of ``Icons.star`` / ``Icons.star_half`` /
    ``Icons.star_border`` glyphs reflecting the current ``value``.
    Supports half-star granularity when ``allow_half`` is ``True``.
    Tapping a star emits ``"rate"`` with the selected 1-based index
    and value.

    Example::

        import butterflyui as bui

        stars = bui.RatingDisplay(value=3.5, max=5, allow_half=True)

    Args:
        value: 
            Current rating value (``0.0``\u2013``max``).
        max: 
            Maximum number of stars (default ``5``, clamped 1\u201310).
        allow_half: 
            If ``True`` half-star icons are shown when the value falls between whole numbers.
        dense: 
            If ``True`` stars are smaller and closer together.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "rating_display"

    def __init__(
        self,
        *,
        value: float | None = None,
        max: int | None = None,
        allow_half: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            max=max,
            allow_half=allow_half,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
