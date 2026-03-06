from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Color"]


class Color(Component):
    """
    Renderable color-value control for swatches and live UI diagnostics.

    ``Color`` serializes color payloads into a visible swatch surface with
    optional labels and metadata. It can be used as a standalone display
    control or embedded in larger layout/overlay UIs to preview runtime tokens,
    theme slots, and dynamic color choices.

    The control accepts string colors, numeric color payloads, and mapping
    payloads, making it compatible with both simple and structured color flows.

    ```python
    import butterflyui as bui

    bui.Color(
        value={"value": "#4F8BFF", "opacity": 0.9},
        label="Primary",
        show_hex=True,
        auto_contrast=True,
    )
    ```

    Args:
        value:
            Primary color payload to resolve and display.
        color:
            Alias for ``value``.
        label:
            Optional label shown with the swatch.
        show_label:
            Whether to render the ``label`` text.
        show_hex:
            Whether to render resolved hex metadata.
        size:
            Base swatch size used when width/height are omitted.
        width:
            Swatch width override.
        height:
            Swatch height override.
        radius:
            Border radius for rectangular shapes.
        shape:
            Swatch shape (for example ``"rectangle"`` or ``"circle"``).
        border_color:
            Optional swatch border color.
        border_width:
            Swatch border width.
        background:
            Optional background for the full control surface.
        auto_contrast:
            Enables automatic foreground contrast when supported.
        min_contrast:
            Minimum target contrast when ``auto_contrast`` is enabled.
        enabled:
            Enables interaction events when supported.
        events:
            Runtime event names to subscribe to.
        props:
            Additional props merged before typed arguments.
        style:
            Optional style map for the control host.
        strict:
            Enables strict schema validation when supported.
        **kwargs:
            Extra runtime props forwarded to the renderer.
    """


    value: Any | None = None
    """
    Primary color payload to resolve and display.
    """

    color: Any | None = None
    """
    Alias for ``value``.
    """

    label: str | None = None
    """
    Optional label shown with the swatch.
    """

    show_label: bool | None = None
    """
    Whether to render the ``label`` text.
    """

    show_hex: bool | None = None
    """
    Whether to render resolved hex metadata.
    """

    size: float | None = None
    """
    Base swatch size used when width/height are omitted.
    """

    radius: float | None = None
    """
    Border radius for rectangular shapes.
    """

    shape: str | None = None
    """
    Swatch shape (for example ``"rectangle"`` or ``"circle"``).
    """

    border_color: Any | None = None
    """
    Optional swatch border color.
    """

    border_width: float | None = None
    """
    Swatch border width.
    """

    background: Any | None = None
    """
    Optional background for the full control surface.
    """

    auto_contrast: bool | None = None
    """
    Enables automatic foreground contrast when supported.
    """

    min_contrast: float | None = None
    """
    Minimum target contrast when ``auto_contrast`` is enabled.
    """

    events: list[str] | None = None
    """
    Runtime event names to subscribe to.
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

