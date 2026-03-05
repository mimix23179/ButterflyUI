from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Color"]


class Color(Component):
    """
    Renderable color value control for swatches, chips, and color diagnostics.

    ``Color`` is a lightweight display control that resolves color payloads and
    renders a visual swatch with optional label/hex metadata. It is designed to
    pair with runtime token systems so color intent can be serialized and
    reused across display/layout/overlay controls.

    Supported value forms:
    - string colors (hex/rgb/hsl/token refs accepted by runtime)
    - integer ARGB values
    - structured maps, such as ``{"value": "#4F8BFF", "opacity": 0.8}``

    Example::

        import butterflyui as bui

        swatch = bui.Color(
            value={"value": "#4F8BFF", "opacity": 0.9},
            label="Primary",
            show_hex=True,
            auto_contrast=True,
        )

    Args:
        value:
            Primary color payload to resolve and display.
        color:
            Alias for ``value``.
        label:
            Optional human-readable name shown next to the swatch.
        show_label:
            Whether to render ``label``.
        show_hex:
            Whether to render hex metadata text.
        size:
            Base swatch size (used when width/height are not provided).
        width:
            Swatch width override.
        height:
            Swatch height override.
        radius:
            Border radius for rectangular swatches.
        shape:
            Swatch shape (for example ``"rectangle"`` or ``"circle"``).
        border_color:
            Optional border color for the swatch.
        border_width:
            Border stroke width.
        background:
            Optional background color for the full control surface.
        auto_contrast:
            When ``True``, runtime tries to keep readable foreground text.
        min_contrast:
            Minimum contrast ratio target when auto-contrast is enabled.
        enabled:
            Enables interaction events when supported.
        events:
            Runtime event names to emit to Python.
    """

    control_type = "color"

    def __init__(
        self,
        value: Any | None = None,
        *,
        color: Any | None = None,
        label: str | None = None,
        show_label: bool | None = None,
        show_hex: bool | None = None,
        size: float | None = None,
        width: float | None = None,
        height: float | None = None,
        radius: float | None = None,
        shape: str | None = None,
        border_color: Any | None = None,
        border_width: float | None = None,
        background: Any | None = None,
        auto_contrast: bool | None = None,
        min_contrast: float | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved_value = color if color is not None else value
        merged = merge_props(
            props,
            value=resolved_value,
            color=resolved_value,
            label=label,
            show_label=show_label,
            show_hex=show_hex,
            size=size,
            width=width,
            height=height,
            radius=radius,
            shape=shape,
            border_color=border_color,
            border_width=border_width,
            background=background,
            auto_contrast=auto_contrast,
            min_contrast=min_contrast,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
