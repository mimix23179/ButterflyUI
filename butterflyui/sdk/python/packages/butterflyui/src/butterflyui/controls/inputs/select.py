from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Select"]

class Select(Component):
    """
    Drop-down select control for choosing one item from a list.

    Renders a Flutter ``DropdownButton`` (or equivalent) that opens an
    option list overlay on tap.  The selected item is identified by
    ``value`` or ``index``.  Selecting a different option emits a
    ``change`` event carrying the new ``value`` and ``index``.

    ```python
    import butterflyui as bui

    bui.Select(
        options=["Small", "Medium", "Large"],
        value="Medium",
        label="Size",
    )
    ```

    Args:
        options:
            List of option items.  Each entry may be a plain string
            or a mapping with ``"label"`` and optional ``"value"``
            keys.
        index:
            Zero-based index of the initially selected option.
        value:
            Value of the initially selected option.
        label:
            Floating label text above the drop-down field.
        hint:
            Hint text shown when no option is selected.
    """
    control_type = "select"

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
        merged = merge_props(
            props,
            options=options,
            index=index,
            value=value,
            label=label,
            hint=hint,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
