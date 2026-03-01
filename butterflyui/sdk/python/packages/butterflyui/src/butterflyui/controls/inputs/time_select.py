from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TimeSelect"]

class TimeSelect(Component):
    """
    Time selection field that opens a Material time-picker dialog.

    Renders a read-only ``TextField`` showing the current time.  Tapping
    the field (or calling :meth:`open`) shows a Flutter
    ``showTimePicker`` dialog.  The selected time is stored as an
    ``HH:MM`` string (24-hour or 12-hour depending on ``use_24h``).
    ``minute_step`` controls the minute-interval granularity of the
    picker wheel.  Time changes emit a ``change`` event.  Use
    :meth:`set_value` and :meth:`get_value` to drive the control from
    Python.

    ```python
    import butterflyui as bui

    bui.TimeSelect(
        label="Meeting time",
        minute_step=15,
        use_24h=True,
    )
    ```

    Args:
        value:
            Currently selected time as ``"HH:MM"``.
        label:
            Floating label text shown above the field.
        placeholder:
            Hint text shown when no time is selected.
        minute_step:
            Granularity of the minute selector in the picker dialog.
            Common values: ``1``, ``5``, ``15``, ``30``.
        use_24h:
            If ``True``, the picker dialog uses 24-hour format.
            If ``False`` (default), 12-hour AM/PM format is used.
        enabled:
            If ``False``, the field is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "time_select"

    def __init__(
        self,
        value: str | None = None,
        *,
        label: str | None = None,
        placeholder: str | None = None,
        minute_step: int | None = None,
        use_24h: bool | None = None,
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
            label=label,
            placeholder=placeholder,
            minute_step=minute_step,
            use_24h=use_24h,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
