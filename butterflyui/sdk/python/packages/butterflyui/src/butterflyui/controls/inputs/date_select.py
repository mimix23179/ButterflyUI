from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .date_picker import DatePicker

__all__ = ["DateSelect"]

class DateSelect(DatePicker):
    """
    Alias for :class:`DatePicker` with a more descriptive class name.

    Provides identical behaviour and parameters to :class:`DatePicker`.
    Both names map to the same ``date_select`` control type on the
    Flutter side.

    ```python
    import butterflyui as bui

    bui.DateSelect(label="Start date", min_date="2020-01-01")
    ```

    Args:
        value:
            Currently selected date as ``"YYYY-MM-DD"``.
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
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "date_select"

    def __init__(
        self,
        value: str | None = None,
        *,
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
            value=value,
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
