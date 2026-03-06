from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ComboBox"]


class ComboBox(Component):
    """
    Editable combo-box input with option lists and async loading hooks.

    ``ComboBox`` is the canonical merged control for both ``combo_box`` and
    legacy ``combobox`` usage. It supports typed input with selectable options,
    grouped option sections, loading state for remote queries, and debounce
    configuration for server-driven suggestion pipelines.

    ```python
    import butterflyui as bui

    field = bui.ComboBox(
        label="Assignee",
        options=[{"label": "Ava", "value": "ava"}],
        async_source="users.search",
        debounce_ms=250,
        events=["change", "query"],
    )
    ```

    Args:
        value:
            Current selected/typed value.
        options:
            Option descriptors shown in the dropdown.
        items:
            Alias for ``options``.
        groups:
            Group descriptors for grouped option sections.
        label:
            Field label text.
        hint:
            Hint text shown when input is empty.
        placeholder:
            Alias for ``hint``.
        loading:
            If ``True``, shows loading affordances.
        async_source:
            Identifier used by your runtime for remote option lookups.
        debounce_ms:
            Debounce window (milliseconds) for query events.
        enabled:
            If ``False``, input is non-interactive.
        events:
            Event names the Flutter side should emit to Python.
        props:
            Raw prop overrides merged after typed arguments.
        style:
            Style map forwarded to the renderer style pipeline.
        strict:
            When ``True``, unknown props raise validation errors.
    """


    value: str | None = None
    """
    Current selected/typed value.
    """

    options: list[Any] | None = None
    """
    Option descriptors shown in the dropdown.
    """

    items: list[Any] | None = None
    """
    Alias for ``options``.
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    Group descriptors for grouped option sections.
    """

    label: str | None = None
    """
    Field label text.
    """

    hint: str | None = None
    """
    Hint text shown when input is empty.
    """

    placeholder: str | None = None
    """
    Alias for ``hint``.
    """

    loading: bool | None = None
    """
    If ``True``, shows loading affordances.
    """

    async_source: str | None = None
    """
    Identifier used by your runtime for remote option lookups.
    """

    debounce_ms: int | None = None
    """
    Debounce window (milliseconds) for query events.
    """

    events: list[str] | None = None
    """
    Event names the Flutter side should emit to Python.
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
            props=merge_props(
                props,
                value=value,
                options=options if options is not None else items,
                items=items if items is not None else options,
                groups=groups,
                label=label,
                hint=hint if hint is not None else placeholder,
                placeholder=placeholder if placeholder is not None else hint,
                loading=loading,
                async_source=async_source,
                debounce_ms=debounce_ms,
                enabled=enabled,
                events=events,
                **kwargs,
            ),
            style=style,
            strict=strict,
        )

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": list(options)})

    def set_loading(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_loading", {"value": value})
