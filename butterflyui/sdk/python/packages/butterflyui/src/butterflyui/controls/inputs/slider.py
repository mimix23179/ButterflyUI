from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Slider"]


class Slider(Component):
    """Single-value or range-value slider input.
    
    ``Slider`` is the merged replacement for legacy ``span_slider``. Use
    ``value`` for standard single-knob behavior, or pass ``start`` and ``end``
    for range mode with two thumbs.
    
    ```python
    import butterflyui as bui
    
    volume = bui.Slider(value=65, min=0, max=100, divisions=20, label="Volume")
    ```
    
    Args:
        value:
            Current value rendered or edited by the control. The exact payload shape depends on the control type.
        start:
            Range start value for dual-thumb mode.
        end:
            Range end value for dual-thumb mode.
        min:
            Minimum value accepted by the control.
        max:
            Maximum value, count, or visible item limit enforced by this control.
        divisions:
            Number of discrete steps between ``min`` and ``max``.
        label:
            Primary label text rendered by the control or its active action.
        labels:
            If ``True``, renderer may display value labels.
        enabled:
            If ``False``, the slider is non-interactive.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    value: float | int | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
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

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    labels: bool | None = None
    """
    If ``True``, renderer may display value labels.
    """

    control_type = "slider"

    def __init__(
        self,
        value: float | int | None = None,
        *,
        start: float | int | None = None,
        end: float | int | None = None,
        min: float | int | None = None,
        max: float | int | None = None,
        divisions: int | None = None,
        label: str | None = None,
        labels: bool | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
                        props,
                        value=value,
                        start=start,
                        end=end,
                        min=min,
                        max=max,
                        divisions=divisions,
                        label=label,
                        labels=labels,
                        enabled=enabled,
                        **kwargs,
                    )
        super().__init__(
            props=merged,
            style=style,
            strict=strict,
        )

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
