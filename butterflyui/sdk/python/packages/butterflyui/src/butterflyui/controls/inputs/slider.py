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
