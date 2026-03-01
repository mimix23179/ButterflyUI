from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .select import Select

__all__ = ["SegmentBar"]

class SegmentBar(Select):
    """
    :class:`Select` rendered as a horizontal segmented button bar.

    Extends :class:`Select` and maps to the ``segment_bar`` control
    type.  The Flutter side renders a Flutter ``SegmentedButton`` row
    where each option appears as a labelled segment.  Selecting a
    segment emits a ``change`` event with the new ``value`` and
    ``index``.

    ```python
    import butterflyui as bui

    bui.SegmentBar(
        options=["Day", "Week", "Month"],
        value="Week",
    )
    ```

    Args:
        options:
            List of option items (strings or ``{"label", "value"}``
            mappings) rendered as individual segments.
        index:
            Zero-based index of the initially selected segment.
        value:
            Value of the initially selected segment.
        label:
            Optional accessible label for the control.
        hint:
            Placeholder text shown when no segment is selected.
    """
    control_type = "segment_bar"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        index: int | None = None,
        value: Any | None = None,
        label: str | None = None,
        hint: str | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            options=options,
            index=index,
            value=value,
            label=label,
            hint=hint,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
