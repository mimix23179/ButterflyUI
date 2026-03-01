from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Radio"]

class Radio(Component):
    """
    Group of radio buttons for mutually exclusive single selection.

    Renders a vertical list of ``RadioListTile`` widgets, one per
    entry in ``options``.  Exactly one option can be active at a
    time.  The active item is identified by ``value`` or ``index``.
    Selecting a different option emits a ``change`` event with the
    new ``value`` and ``index``.

    ```python
    import butterflyui as bui

    bui.Radio(
        options=["Option A", "Option B", "Option C"],
        value="Option A",
        label="Choose one",
    )
    ```

    Args:
        options:
            List of option items.  Each entry may be a plain string
            or a mapping with ``"label"`` and ``"value"`` keys.
        index:
            Zero-based index of the initially selected option.
        value:
            Value of the initially selected option.  Takes precedence
            over ``index`` when both are provided.
        label:
            Optional label rendered above the radio group.
    """
    control_type = "radio"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        index: int | None = None,
        value: Any | None = None,
        label: str | None = None,
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
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)
