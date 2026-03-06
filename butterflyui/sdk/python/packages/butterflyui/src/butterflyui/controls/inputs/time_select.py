from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..form_field_control import FormFieldControl

__all__ = ["TimeSelect"]

@butterfly_control('time_select', positional_fields=('value',))
class TimeSelect(FormFieldControl):
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

    Example:

    ```python
    import butterflyui as bui

    bui.TimeSelect(
        label="Meeting time",
        minute_step=15,
        use_24h=True,
    )
    ```
    """

    minute_step: int | None = None
    """
    Granularity of the minute selector in the picker dialog.
    Common values: ``1``, ``5``, ``15``, ``30``.
    """

    use_24h: bool | None = None
    """
    If ``True``, the picker dialog uses 24-hour format.
    If ``False`` (default), 12-hour AM/PM format is used.
    """

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
