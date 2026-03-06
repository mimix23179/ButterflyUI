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

    def emit(self, session: Any, event: str = "click", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
