from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Shadow"]

class Shadow(Component):
    """Box-shadow decorator that wraps children in a ``DecoratedBox``
    with configurable ``BoxShadow`` entries.

    The Flutter runtime renders either a single shadow from the
    shorthand parameters (*color*, *blur*, *spread*, *offset_x*,
    *offset_y*) or a full list of shadow definitions via *shadows*.
    An optional *radius* rounds the decoration corners.

    Example::

        import butterflyui as bui

        card = bui.Shadow(
            bui.Container(width=200, height=120),
            color="#00000033",
            blur=12,
            offset_y=4,
            radius=8,
        )

    Args:
        color: 
            Shadow colour.  Defaults to ``#33000000`` (20 %
            black).
        blur: 
            Blur radius of the shadow.  Defaults to ``12``.
        spread: 
            Spread radius.  Defaults to ``0``.
        offset_x: 
            Horizontal shadow offset.  Defaults to ``0``.
        offset_y: 
            Vertical shadow offset.  Defaults to ``4``.
        radius: 
            Corner radius of the ``BoxDecoration``.  Defaults to
            ``0`` (sharp corners).
        shadows: 
            Explicit list of shadow definition mappings, each
            with ``color``, ``blur``, ``spread``, ``offset_x``,
            ``offset_y``.  Overrides the shorthand parameters.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "shadow"

    def __init__(
        self,
        child: Any | None = None,
        *children: Any,
        color: Any | None = None,
        blur: float | None = None,
        spread: float | None = None,
        offset_x: float | None = None,
        offset_y: float | None = None,
        radius: float | None = None,
        shadows: list[Mapping[str, Any]] | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            color=color,
            blur=blur,
            spread=spread,
            offset_x=offset_x,
            offset_y=offset_y,
            radius=radius,
            shadows=[dict(shadow) for shadow in (shadows or [])],
            events=events,
            **kwargs,
        )
        resolved_children = list(children)
        if child is not None:
            resolved_children.insert(0, child)
        super().__init__(*resolved_children, props=merged, style=style, strict=strict)
