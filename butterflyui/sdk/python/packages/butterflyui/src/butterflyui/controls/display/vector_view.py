from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["VectorView"]

class VectorView(Component):
    """Simple vector shape viewer.

    Renders a ``Container`` of a given ``width`` and ``height``
    containing a basic vector shape (``"rect"``, ``"circle"``, or
    ``"triangle"``).  The shape is filled with ``fill`` colour and
    optionally stroked.  Use the ``src`` or ``data`` parameters to
    load SVG content when the runtime adds extended support.

    Example::

        import butterflyui as bui

        vec = bui.VectorView(
            src="/assets/logo.svg",
            width=120,
            height=120,
            fit="contain",
        )

    Args:
        src: 
            URI or asset path to an SVG or vector resource.
        data: 
            Inline SVG data string.
        fit: 
            Box-fit mode (e.g. ``"contain"``, ``"cover"``).
        color: 
            Foreground colour applied to the vector content.
        tint: 
            Tint colour overlaid on the graphic.
        opacity: 
            Opacity from ``0.0`` (transparent) to ``1.0``.
        width: 
            Container width in logical pixels.
        height: 
            Container height in logical pixels.
        alignment: 
            Content alignment inside the container.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "vector_view"

    def __init__(
        self,
        *,
        src: str | None = None,
        data: str | None = None,
        fit: str | None = None,
        color: Any | None = None,
        tint: Any | None = None,
        opacity: float | None = None,
        width: float | None = None,
        height: float | None = None,
        alignment: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            src=src,
            data=data,
            fit=fit,
            color=color,
            tint=tint,
            opacity=opacity,
            width=width,
            height=height,
            alignment=alignment,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
