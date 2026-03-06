from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..toggle_control import ToggleControl

__all__ = ["Switch"]

@butterfly_control('switch', positional_fields=('value',))
class Switch(ToggleControl):
    """
    Boolean switch input with optional segmented presentation.

    ``Switch`` now also covers segmented-switch use cases through ``mode`` and
    ``segments``. In default mode it behaves like a standard on/off toggle;
    segmented mode allows richer labels and grouped state presentation.

    Example:

    ```python
    import butterflyui as bui

    toggle = bui.Switch(
        value=True,
        label="Notifications",
        on_label="On",
        off_label="Off",
    )
    ```
    """

    inline: bool | None = None
    """
    If ``True``, aligns label and switch inline.
    """

    mode: str | None = None
    """
    Rendering mode (for example ``"toggle"`` or ``"segmented"``
    depending on renderer support).
    """

    on_label: str | None = None
    """
    Label text shown when the control is in its on or enabled state.
    """

    off_label: str | None = None
    """
    Label text shown when the control is in its off or disabled state.
    """

    segments: list[Any] | None = None
    """
    Segment descriptors for segmented presentation mode.
    """

    options: Any | None = None
    """
    Option descriptors rendered by the control.
    """

    index: Any | None = None
    """
    Index value forwarded to the `switch` runtime control.
    """

    def set_value(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
