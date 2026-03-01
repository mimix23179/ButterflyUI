from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ComboBox"]

class ComboBox(Component):
    """
    Alias for :class:`Combobox` with a PascalCase class name.

    Provides identical behaviour and parameters to :class:`Combobox`.
    Use whichever spelling matches your codebase convention.

    ```python
    import butterflyui as bui

    bui.ComboBox(options=["One", "Two", "Three"], label="Pick one")
    ```

    Args:
        value:
            Currently entered/selected text value.
        options:
            Flat list of option items (strings or mappings with
            ``"label"``/``"value"`` keys).
        items:
            Alias for ``options``.
        groups:
            List of grouped option sections — each a mapping with
            ``"label"`` and ``"options"`` keys.
        label:
            Floating label text above the field.
        hint:
            Hint/placeholder text shown when the field is empty.
        placeholder:
            Alias for ``hint``.
        loading:
            If ``True``, a progress indicator is shown in the dropdown.
        async_source:
            Enables async mode — see :class:`Combobox`.
        debounce_ms:
            Milliseconds to debounce typed input in async mode.
        enabled:
            If ``False``, the field is non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "combo_box"

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
