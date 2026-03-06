from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GlyphButton"]

class GlyphButton(Component):
    """
    Unified glyph/icon surface with optional button interaction.
    
    ``GlyphButton`` is the merged control for legacy ``glyph`` and
    ``glyph_button`` behavior. It can render as an interactive icon trigger or
    as a passive visual glyph by setting ``interactive=False``.
    
    ``glyph`` and ``icon`` are interchangeable aliases. Event subscriptions are
    forwarded to runtime so this control can participate in action pipelines,
    overlays, and other interaction flows.
    
    ```python
    import butterflyui as bui
    
    bui.GlyphButton(
        glyph="settings",
        tooltip="Preferences",
        size=18,
        color="#8BD3FF",
        events=["click"],
    )
    ```
    """


    glyph: str | int | None = None
    """
    Icon name, codepoint, or glyph string payload.
    """

    icon: str | int | None = None
    """
    Backward-compatible alias for ``glyph``. When both fields are provided, ``glyph`` takes precedence and this alias is kept only for compatibility.
    """

    size: float | None = None
    """
    Requested icon, glyph, or control size in logical pixels or runtime size units.
    """

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """

    interactive: bool | None = None
    """
    If ``False``, renders as a passive glyph without button semantics.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
        interactive: bool | None = None,
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
            interactive=interactive,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})

