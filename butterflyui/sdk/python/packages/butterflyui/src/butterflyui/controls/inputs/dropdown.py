from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Dropdown"]

class Dropdown(Component):
    """
    Non-editable drop-down select rendered as a ``Combobox``.
    
    Extends :class:`Combobox` but maps to the ``dropdown`` control type
    on the Flutter side, which may render as a pure select-only
    dropdown rather than an editable text field.  Supports the same
    option, grouping, async-source, and imperative methods as
    :class:`Combobox`.

    Example:
    
    ```python
    import butterflyui as bui
    
    bui.Dropdown(
        options=["Small", "Medium", "Large"],
        label="Size",
        value="Medium",
    )
    ```
    """


    value: str | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    options: list[Any] | None = None
    """
    List of option items (strings or ``{"label", "value"}``
    mappings).
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    List of grouped option sections, each with
    ``"label"`` and ``"options"`` keys.
    """

    label: str | None = None
    """
    Floating label text above the field.
    """

    hint: str | None = None
    """
    Hint/placeholder text shown when nothing is selected.
    """

    placeholder: str | None = None
    """
    Backward-compatible alias for ``hint``. When both fields are provided, ``hint`` takes precedence and this alias is kept only for compatibility.
    """

    loading: bool | None = None
    """
    If ``True``, a progress indicator is shown.
    """

    async_source: str | None = None
    """
    Async data source identifier or configuration used to fetch items for this control on demand.
    """

    debounce_ms: int | None = None
    """
    Debounce delay in milliseconds for async input events.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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
