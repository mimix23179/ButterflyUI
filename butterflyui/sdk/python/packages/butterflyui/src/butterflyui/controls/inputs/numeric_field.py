from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["NumericField"]

class NumericField(Component):
    """
    Text field constrained to numeric input with optional bounds.

    Renders a Flutter ``TextField`` with a numeric keyboard and
    built-in increment / decrement arrow buttons.  Input is
    restricted to numbers within the optional ``min`` / ``max`` range.
    ``decimals`` controls how many decimal places are allowed;
    setting it to ``0`` forces integer-only input.  Changes emit a
    ``change`` event with the validated numeric value.  Use
    :meth:`set_value` and :meth:`get_value` to drive the field
    programmatically.

    ```python
    import butterflyui as bui

    bui.NumericField(
        value=0,
        min=0,
        max=100,
        step=5,
        label="Quantity",
    )
    ```

    Args:
        value:
            Current numeric value.
        min:
            Minimum allowed value (inclusive).
        max:
            Maximum allowed value (inclusive).
        step:
            Increment/decrement step used by the arrow buttons.
        decimals:
            Number of decimal places allowed.  ``0`` enforces
            integer-only input.
        placeholder:
            Hint text shown when the field is empty.
        label:
            Floating label text above the field.
        enabled:
            If ``False``, the field is non-interactive.
        dense:
            If ``True``, the field uses compact height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "numeric_field"

    def __init__(
        self,
        value: float | int | None = None,
        *,
        min: float | None = None,
        max: float | None = None,
        step: float | None = None,
        decimals: int | None = None,
        placeholder: str | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            min=min,
            max=max,
            step=step,
            decimals=decimals,
            placeholder=placeholder,
            label=label,
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: float | int) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
