from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DateRangePicker"]

class DateRangePicker(Component):
    """
    Date-range picker with separate start and end date fields.

    Renders two linked date fields (``start`` and ``end``) backed by
    a Flutter ``showDateRangePicker`` dialog.  Both dates are stored as
    ISO-8601 strings.  Selecting a range emits a ``change`` event with
    ``{"start": "...", "end": "..."}``.  Use :meth:`set_value` to
    update one or both dates imperatively, and :meth:`get_value` to
    read the current range.

    ```python
    import butterflyui as bui

    bui.DateRangePicker(
        start="2025-01-01",
        end="2025-12-31",
        label="Date range",
    )
    ```

    Args:
        start:
            Start date of the range as ``"YYYY-MM-DD"``.
        end:
            End date of the range as ``"YYYY-MM-DD"``.
        label:
            Label text shown above the range fields.
        placeholder:
            Hint text shown when no dates are selected.
        min_date:
            Earliest selectable date as ``"YYYY-MM-DD"``.
        max_date:
            Latest selectable date as ``"YYYY-MM-DD"``.
        enabled:
            If ``False``, the control is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "date_range_picker"

    def __init__(
        self,
        *,
        start: str | None = None,
        end: str | None = None,
        label: str | None = None,
        placeholder: str | None = None,
        min_date: str | None = None,
        max_date: str | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            start=start,
            end=end,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def open(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "open", {})

    def clear(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "clear", {})

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, start: str | None = None, end: str | None = None) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if start is not None:
            payload["start"] = start
        if end is not None:
            payload["end"] = end
        return self.invoke(session, "set_value", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
