from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .progress_indicator import ProgressIndicator

__all__ = ["Progress"]

class Progress(ProgressIndicator):
    """
    Convenience alias for ``ProgressIndicator`` that adds an ``events``
    parameter and a ``set_value()`` invoke helper.

    All visual behaviour is identical to ``ProgressIndicator``; this
    subclass simply makes it easier to wire up event subscriptions and
    push value updates from Python.

    ```python
    import butterflyui as bui

    bui.Progress(
        value=0.65,
        label="Uploading…",
        circular=False,
    )
    ```

    Args:
        value: 
            Fractional progress in the range ``0.0`` – ``1.0``.  When ``None`` and ``indeterminate`` is not set, the indicator is empty.
        indeterminate: 
            If ``True``, the indicator plays a looping animation instead of showing a determinate fill.
        label: 
            Optional text label rendered alongside the indicator.
        variant: 
            Layout variant hint — ``"linear"`` or ``"circular"``.
        circular: 
            Shortcut flag: when ``True`` equivalent to ``variant="circular"``.
        stroke_width: 
            Stroke width in logical pixels used when painting the indicator arc or bar.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "progress"

    def __init__(
        self,
        *,
        value: float | None = None,
        indeterminate: bool | None = None,
        label: str | None = None,
        variant: str | None = None,
        circular: bool | None = None,
        stroke_width: float | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            indeterminate=indeterminate,
            label=label,
            variant=variant,
            circular=circular,
            stroke_width=stroke_width,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_value(self, session: Any, value: float) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": float(value)})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
