from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["GlyphButton"]

class GlyphButton(Component):
    """
    Icon glyph surface with optional button behavior.

    ``GlyphButton`` is the canonical icon control after merging legacy
    ``glyph`` and ``glyph_button`` concepts. It can behave as an interactive
    icon button or as a static icon-like glyph when ``interactive=False``.
    ``glyph`` and ``icon`` are interchangeable aliases.

    When events are subscribed, the Flutter side can emit ``click``-style
    interaction messages back to Python.

    ```python
    import butterflyui as bui

    btn = bui.GlyphButton(
        glyph="delete",
        tooltip="Remove item",
        size=20,
        events=["click"],
    )
    ```

    Args:
        glyph:
            Icon name, codepoint, or emoji string.
        icon:
            Alias for ``glyph``.
        tooltip:
            Hover/assistive tooltip text.
        size:
            Icon size in logical pixels.
        color:
            Icon foreground color.
        enabled:
            If ``False``, the control is disabled.
        interactive:
            If ``False``, renders without button chrome/gestures.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
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
