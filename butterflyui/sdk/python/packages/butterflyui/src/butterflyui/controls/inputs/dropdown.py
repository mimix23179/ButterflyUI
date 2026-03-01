from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .combobox import Combobox

__all__ = ["Dropdown"]

class Dropdown(Combobox):
    """
    Non-editable drop-down select rendered as a ``Combobox``.

    Extends :class:`Combobox` but maps to the ``dropdown`` control type
    on the Flutter side, which may render as a pure select-only
    dropdown rather than an editable text field.  Supports the same
    option, grouping, async-source, and imperative methods as
    :class:`Combobox`.

    ```python
    import butterflyui as bui

    bui.Dropdown(
        options=["Small", "Medium", "Large"],
        label="Size",
        value="Medium",
    )
    ```

    Args:
        value:
            Currently selected value.
        options:
            List of option items (strings or ``{"label", "value"}``
            mappings).
        items:
            Alias for ``options``.
        groups:
            List of grouped option sections, each with
            ``"label"`` and ``"options"`` keys.
        label:
            Floating label text above the field.
        hint:
            Hint/placeholder text shown when nothing is selected.
        placeholder:
            Alias for ``hint``.
        loading:
            If ``True``, a progress indicator is shown.
        async_source:
            Enables async filtering mode.
        debounce_ms:
            Debounce delay in milliseconds for async input events.
        enabled:
            If ``False``, the control is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "dropdown"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        groups: list[Mapping[str, Any]] | None = None,
        label: str | None = None,
        hint: str | None = None,
        placeholder: str | None = None,
        loading: bool | None = None,
        async_source: str | None = None,
        debounce_ms: int | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            value=value,
            options=options,
            items=items,
            groups=groups,
            label=label,
            hint=hint,
            placeholder=placeholder,
            loading=loading,
            async_source=async_source,
            debounce_ms=debounce_ms,
            enabled=enabled,
            events=events,
            props=props,
            style=style,
            strict=strict,
            **kwargs,
        )
