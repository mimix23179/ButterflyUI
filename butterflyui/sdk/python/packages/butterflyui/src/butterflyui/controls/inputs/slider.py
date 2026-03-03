from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["Slider"]


class Slider(Component):
    """Single-value or range-value slider.

    ``Slider`` now replaces ``span_slider``. Provide ``start`` and ``end`` to
    enable range mode.
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
