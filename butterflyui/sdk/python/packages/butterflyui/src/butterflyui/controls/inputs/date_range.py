from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .date_range_picker import DateRangePicker

__all__ = ["DateRange"]

class DateRange(DateRangePicker):
    """
    Alias for :class:`DateRangePicker` with a shorter class name.

    Provides identical behaviour and parameters to
    :class:`DateRangePicker`.  Use whichever name reads more cleanly
    in your codebase.

    ```python
    import butterflyui as bui

    bui.DateRange(start="2025-06-01", end="2025-06-30", label="Sprint")
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
    control_type = "date_range"

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
        super().__init__(
            start=start,
            end=end,
            label=label,
            placeholder=placeholder,
            min_date=min_date,
            max_date=max_date,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
