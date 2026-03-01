from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from ._eventful_effect import _EventfulEffect

__all__ = ["ShadowStack"]

class ShadowStack(_EventfulEffect):
    """Multi-layer box-shadow stack applied to a child via a
    ``Container`` with a rounded ``BoxDecoration``.

    The Flutter runtime parses the *shadows* list into multiple
    ``BoxShadow`` entries (each with colour, blur, spread, and offset)
    and renders them as a single ``Container`` decoration.  If no
    shadows are provided a sensible two-layer default is used.

    Example::

        import butterflyui as bui

        stack = bui.ShadowStack(
            bui.Text("Elevated"),
            shadows=[
                {"color": "#1F000000", "blur": 8, "offset_y": 2},
                {"color": "#14000000", "blur": 20, "offset_y": 8},
            ],
            radius=12,
        )

    Args:
        shadows: 
            List of shadow definition mappings.  Each may contain ``color``, ``blur``, ``spread``, ``offset_x``,
            and ``offset_y``.  Defaults to a two-layer elevation preset.
        radius: 
            Corner radius of the ``BoxDecoration``.  Defaults to
            ``12``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "shadow_stack"

    def __init__(
        self,
        child: Any | None = None,
        *,
        shadows: list[Mapping[str, Any]] | None = None,
        radius: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            child=child,
            events=events,
            props=props,
            style=style,
            strict=strict,
            shadows=[dict(shadow) for shadow in (shadows or [])],
            radius=radius,
            **kwargs,
        )
