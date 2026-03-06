from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl


__all__ = ["Slider"]

@butterfly_control('slider', positional_fields=('value',))
class Slider(FormFieldControl):
    """
    Single-value or range-value slider input.

    ``Slider`` is the merged replacement for legacy ``span_slider``. Use
    ``value`` for standard single-knob behavior, or pass ``start`` and ``end``
    for range mode with two thumbs.

    Example:

    ```python
    import butterflyui as bui

    volume = bui.Slider(
        value=65,
        min=0,
        max=100,
        divisions=20,
        label="Volume"
    )
    ```
    """

    start: float | int | None = None
    """
    Range start value for dual-thumb mode.
    """

    end: float | int | None = None
    """
    Range end value for dual-thumb mode.
    """

    min: float | int | None = None
    """
    Minimum value accepted by the control.
    """

    max: float | int | None = None
    """
    Maximum value, count, or visible item limit enforced by this control.
    """

    divisions: int | None = None
    """
    Number of discrete steps between ``min`` and ``max``.
    """

    labels: bool | None = None
    """
    If ``True``, renderer may display value labels.
    """

    color: Any | None = None
    """
    Primary color value applied to the control.
    """

    foreground: Any | None = None
    """
    Foreground value forwarded to the `slider` runtime control.
    """

    text_color: Any | None = None
    """
    Text color value forwarded to the `slider` runtime control.
    """

    icon_color: Any | None = None
    """
    Icon color value forwarded to the `slider` runtime control.
    """

    icon_background: Any | None = None
    """
    Icon background value forwarded to the `slider` runtime control.
    """

    icon_foreground: Any | None = None
    """
    Icon foreground value forwarded to the `slider` runtime control.
    """

    icon_opacity: Any | None = None
    """
    Icon opacity value forwarded to the `slider` runtime control.
    """

    background: Any | None = None
    """
    Background value forwarded to the `slider` runtime control.
    """

    bgcolor: Any | None = None
    """
    Background color painted behind the control.
    """

    surface_color: Any | None = None
    """
    Surface color value forwarded to the `slider` runtime control.
    """

    border_color: Any | None = None
    """
    Border color used by the runtime.
    """

    scrim_color: Any | None = None
    """
    Scrim color value forwarded to the `slider` runtime control.
    """

    icon: Any | None = None
    """
    Icon descriptor rendered by the control.
    """

    leading_icon: Any | None = None
    """
    Leading icon value forwarded to the `slider` runtime control.
    """

    trailing_icon: Any | None = None
    """
    Trailing icon value forwarded to the `slider` runtime control.
    """

    icon_position: Any | None = None
    """
    Icon position value forwarded to the `slider` runtime control.
    """

    icon_size: Any | None = None
    """
    Icon size value forwarded to the `slider` runtime control.
    """

    icon_spacing: Any | None = None
    """
    Icon spacing value forwarded to the `slider` runtime control.
    """

    decorate_icon: Any | None = None
    """
    Decorate icon value forwarded to the `slider` runtime control.
    """

    transparency: Any | None = None
    """
    Transparency value forwarded to the `slider` runtime control.
    """

    alpha: Any | None = None
    """
    Alpha value forwarded to the `slider` runtime control.
    """

    auto_contrast: Any | None = None
    """
    Auto contrast value forwarded to the `slider` runtime control.
    """

    min_contrast: Any | None = None
    """
    Min contrast value forwarded to the `slider` runtime control.
    """

    def set_value(
        self,
        session: Any,
        value: float | int | None = None,
        *,
        start: float | int | None = None,
        end: float | int | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if value is not None:
            payload["value"] = float(value)
        if start is not None:
            payload["start"] = float(start)
        if end is not None:
            payload["end"] = float(end)
        return self.invoke(session, "set_value", payload)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})
