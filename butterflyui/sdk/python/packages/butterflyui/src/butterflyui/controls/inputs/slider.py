from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Slider"]


class Slider(Component):
    """
    Single-value or range-value slider input.

    ``Slider`` is the merged replacement for legacy ``span_slider``. Use
    ``value`` for standard single-knob behavior, or pass ``start`` and ``end``
    for range mode with two thumbs.

    ```python
    import butterflyui as bui

    volume = bui.Slider(value=65, min=0, max=100, divisions=20, label="Volume")
    ```

    Args:
        value:
            Single-value slider position.
        start:
            Range start value for dual-thumb mode.
        end:
            Range end value for dual-thumb mode.
        min:
            Minimum allowed value.
        max:
            Maximum allowed value.
        divisions:
            Number of discrete steps between ``min`` and ``max``.
        label:
            Optional label/caption text.
        labels:
            If ``True``, renderer may display value labels.
        enabled:
            If ``False``, the slider is non-interactive.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    value: float | int | None = None
    """
    Single-value slider position.
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
    Minimum allowed value.
    """

    max: float | int | None = None
    """
    Maximum allowed value.
    """

    divisions: int | None = None
    """
    Number of discrete steps between ``min`` and ``max``.
    """

    label: str | None = None
    """
    Optional label/caption text.
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
        super().__init__(
            props=merge_props(
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
            ),
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
