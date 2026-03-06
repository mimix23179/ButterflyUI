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

    def set_value(self, session: Any, value: Any) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
