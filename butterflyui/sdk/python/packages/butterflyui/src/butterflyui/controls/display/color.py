from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..layout_control import LayoutControl


__all__ = ["Color"]

@butterfly_control('color', positional_fields=('value',))
class Color(LayoutControl):
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
    """

    value: Any | None = None
    """
    Primary color payload to resolve and display.
    """

    color: Any | None = None
    """
    Backward-compatible alias for ``value``. When both fields are provided, ``value`` takes precedence and this alias is kept only for compatibility.
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
    Border color applied to the outer edge of the rendered control or decorative surface.
    """

    border_width: float | None = None
    """
    Border thickness used when rendering the outline around the control.
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

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `color` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `color` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `color` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `color` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `color` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `color` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `color` runtime control.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `color` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `color` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `color` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `color` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `color` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `color` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `color` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `color` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `color` runtime control.
    """

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
