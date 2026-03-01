from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NeonEdge"]

class NeonEdge(Component):
    """Neon-glow border effect rendered as a ``BoxDecoration`` with a
    coloured ``Border.all`` stroke and a matching ``BoxShadow``.

    The Flutter runtime wraps the child in either a plain ``Container``
    or an ``AnimatedContainer`` (when ``animated`` is ``True``), whose
    ``BoxDecoration`` combines a coloured border, a glow shadow, and a
    corner radius.

    Example::

        import butterflyui as bui

        neon = bui.NeonEdge(
            bui.Text("Glow"),
            color="#22d3ee",
            width=2,
            glow=12,
            radius=12,
            animated=True,
        )

    Args:
        color: 
            Border and glow colour.  Defaults to ``#22D3EE``.
        width: 
            Border stroke width in logical pixels.  Defaults to
            ``1.6``.
        glow: 
            Blur radius of the outer glow ``BoxShadow``.  Defaults
            to ``10``.
        spread: 
            Spread radius of the glow shadow.  Defaults to ``0``.
        radius: 
            Corner radius of the ``BoxDecoration``.  Defaults to
            ``12``.
        animated: 
            When ``True`` the container uses
            ``AnimatedContainer`` for smooth property transitions.
        duration_ms: 
            Animation duration in milliseconds when
            *animated* is ``True``.  Defaults to ``300``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "neon_edge"

    def __init__(
        self,
        child: Any | None = None,
        *,
        color: Any | None = None,
        width: float | None = None,
        glow: float | None = None,
        spread: float | None = None,
        radius: float | None = None,
        animated: bool | None = None,
        duration_ms: int | None = None,
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
            color=color,
            width=width,
            glow=glow,
            spread=spread,
            radius=radius,
            animated=animated,
            duration_ms=duration_ms,
            **kwargs,
        )
