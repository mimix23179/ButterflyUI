from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GlyphButton"]

class GlyphButton(Component):
    """Icon button that emits click-like events.

    Renders a Material ``IconButton`` resolved from``glyph`` or
    ``icon`` via ``buildIconValue``.  When pressed the button emits
    ``"click"`` (and optionally ``"press"``, ``"tap"``, ``"action"``)
    depending on which events are subscribed.  Declarative ``action``/
    ``actions`` props allow the runtime to chain custom event payloads
    without additional Python code.

    When ``enabled`` is ``False`` the button is greyed out and does
    not respond to taps.  A ``tooltip`` wraps the button when present.

    Example::

        import butterflyui as bui

        btn = bui.GlyphButton(
            glyph="delete",
            tooltip="Remove item",
            events=["click"],
        )

    Args:
        glyph: 
            Icon name, code-point, or emoji string.
        icon: 
            Alias for ``glyph``.
        tooltip: 
            Hover tooltip text for the button.
        size: 
            Icon size in logical pixels.
        color: 
            Icon foreground colour.
        enabled: 
            If ``False`` the button is disabled.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "glyph_button"

    def __init__(
        self,
        glyph: str | int | None = None,
        *,
        icon: str | int | None = None,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            glyph=glyph if glyph is not None else icon,
            icon=icon if icon is not None else glyph,
            tooltip=tooltip,
            size=size,
            color=color,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
