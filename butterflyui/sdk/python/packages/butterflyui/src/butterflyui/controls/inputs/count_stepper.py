from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CountStepper"]

class CountStepper(Component):
    """
    Numeric stepper with increment and decrement buttons.

    Renders a row containing a decrement button, the current value
    label, and an increment button.  The step size, minimum, and
    maximum bounds are configurable.  When ``wrap`` is ``True`` the
    value wraps around from ``max`` to ``min`` (and vice versa).
    Each tap emits a ``change`` event with the updated numeric value.
    The value can also be changed imperatively via :meth:`set_value`,
    :meth:`increment`, and :meth:`decrement`.

    ```python
    import butterflyui as bui

    bui.CountStepper(value=1, min=0, max=10, step=1)
    ```

    Args:
        value:
            Current numeric value.
        min:
            Minimum allowed value (inclusive).
        max:
            Maximum allowed value (inclusive).
        step:
            Amount added or subtracted on each tap.  Defaults to ``1``.
        wrap:
            If ``True``, the value wraps around when it reaches
            ``min`` or ``max``.
        enabled:
            If ``False``, both buttons are disabled.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "count_stepper"

    def __init__(
        self,
        *,
        value: int | float | None = None,
        min: int | float | None = None,
        max: int | float | None = None,
        step: int | float | None = None,
        wrap: bool | None = None,
        enabled: bool | None = None,
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
            wrap=wrap,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_value(self, session: Any, value: int | float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def increment(self, session: Any, amount: int | float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if amount is not None:
            payload["amount"] = amount
        return self.invoke(session, "increment", payload)

    def decrement(self, session: Any, amount: int | float | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if amount is not None:
            payload["amount"] = amount
        return self.invoke(session, "decrement", payload)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
