from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..button_control import ButtonControl

__all__ = ["GlyphButton"]

@butterfly_control('glyph_button', positional_fields=('glyph',))
class GlyphButton(ButtonControl):
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

    color: Any | None = None
    """
    Primary color value used by the control for text, icons, strokes, or accent surfaces.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `glyph_button` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `glyph_button` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `glyph_button` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `glyph_button` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `glyph_button` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `glyph_button` runtime control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `glyph_button` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `glyph_button` runtime control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `glyph_button` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `glyph_button` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `glyph_button` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `glyph_button` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `glyph_button` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `glyph_button` runtime control.
    """

    transparency: float | None = None
    """
    Transparency value forwarded to the `glyph_button` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `glyph_button` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `glyph_button` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `glyph_button` runtime control.
    """

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
