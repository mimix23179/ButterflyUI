from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Checkbox"]

class Checkbox(Component):
    """
    Single boolean check-box with an optional text label.

    Renders a Flutter ``Checkbox`` (or ``CheckboxListTile`` when
    ``label`` is provided).  When ``tristate`` is ``True`` the control
    cycles through ``True``, ``False``, and ``None`` (indeterminate).
    Toggling the checkbox emits a ``change`` event with the new value.

    ```python
    import butterflyui as bui

    bui.Checkbox(value=True, label="Accept terms")
    ```

    Args:
        value:
            Current checked state — ``True``, ``False``, or ``None``
            (indeterminate) when ``tristate`` is enabled.
        label:
            Optional text rendered beside the checkbox.
        tristate:
            If ``True``, the checkbox supports a third ``None``
            (indeterminate) state in addition to checked/unchecked.
    """
    control_type = "checkbox"

    def __init__(
        self,
        value: bool | None = None,
        *,
        label: str | None = None,
        tristate: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            label=label,
            tristate=tristate,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
