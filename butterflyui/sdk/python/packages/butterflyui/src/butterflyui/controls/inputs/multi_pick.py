from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .multi_select import MultiSelect

__all__ = ["MultiPick"]

class MultiPick(MultiSelect):
    """
    Alias for :class:`MultiSelect` with a shorter class name.

    Provides identical behaviour and parameters to
    :class:`MultiSelect`.  Use whichever name reads more naturally
    in your code.

    ```python
    import butterflyui as bui

    bui.MultiPick(
        options=["Red", "Green", "Blue"],
        values=["Red"],
        label="Colours",
    )
    ```

    Args:
        options:
            List of option items (strings or ``{"label", "value"}``
            mappings).
        values:
            Currently selected values.  Alias ``selected`` is kept
            in sync.
        selected:
            Alias for ``values``.
        label:
            Label text shown above or inside the selector.
        enabled:
            If ``False``, the control is non-interactive.
    """
    control_type = "multi_pick"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        selected: list[Any] | None = None,
        label: str | None = None,
        enabled: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            options=options,
            values=values,
            selected=selected,
            label=label,
            enabled=enabled,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
