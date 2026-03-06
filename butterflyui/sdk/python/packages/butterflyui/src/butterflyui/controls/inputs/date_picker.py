from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["DatePicker"]

class DatePicker(Component):
    """Date picker supporting single date, range, and span workflows.
    
    ``DatePicker`` unifies legacy controls into one API via ``mode``:
    - ``"single"`` replaces ``date_select``
    - ``"range"`` replaces ``date_range_picker`` / ``date_range``
    - ``"span"`` replaces ``date_span``
    
    Use :meth:`open` to programmatically open the picker and :meth:`set_value`
    to update single or range selections from server-side handlers.
    
    ```python
    import butterflyui as bui
    
    bui.DatePicker(
        label="Period",
        mode="range",
        min_date="1900-01-01",
        max_date="2099-12-31",
    )
    ```
    
    Args:
        value:
            Selected date as ``"YYYY-MM-DD"`` when ``mode="single"``.
        start:
            Range start date when ``mode`` is ``"range"`` or ``"span"``.
        end:
            Range end date when ``mode`` is ``"range"`` or ``"span"``.
        mode:
            ``"single"`` (default), ``"range"``, or ``"span"``.
        label:
            Floating label text shown above the field.
        placeholder:
            Hint text shown when no date is selected.
        min_date:
            Earliest selectable date as ``"YYYY-MM-DD"``.
        max_date:
            Latest selectable date as ``"YYYY-MM-DD"``.
        enabled:
            If ``False``, the field is non-interactive.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    value: str | None = None
    """
    Selected date as ``"YYYY-MM-DD"`` when ``mode="single"``.
    """

    start: str | None = None
    """
    Range start date when ``mode`` is ``"range"`` or ``"span"``.
    """

    end: str | None = None
    """
    Range end date when ``mode`` is ``"range"`` or ``"span"``.
    """

    mode: str | None = None
    """
    ``"single"`` (default), ``"range"``, or ``"span"``.
    """

    label: str | None = None
    """
    Floating label text shown above the field.
    """

    placeholder: str | None = None
    """
    Hint text shown when no date is selected.
    """

    min_date: str | None = None
    """
    Earliest selectable date as ``"YYYY-MM-DD"``.
    """

    max_date: str | None = None
    """
    Latest selectable date as ``"YYYY-MM-DD"``.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "date_picker"

    def __init__(
        self,
        value: str | None = None,
        *,
        start: str | None = None,
        end: str | None = None,
        mode: str | None = None,
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
            value=value,
            start=start,
            end=end,
            mode=mode,
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

    def set_value(
        self,
        session: Any,
        value: str | None = None,
        *,
        start: str | None = None,
        end: str | None = None,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {}
        if value is not None:
            payload["value"] = value
        if start is not None:
            payload["start"] = start
        if end is not None:
            payload["end"] = end
        return self.invoke(session, "set_value", payload)

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
