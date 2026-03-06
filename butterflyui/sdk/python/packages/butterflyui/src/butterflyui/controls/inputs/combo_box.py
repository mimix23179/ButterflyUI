from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import Component, merge_props

__all__ = ["ComboBox"]


class ComboBox(Component):
    """Editable combo-box input with option lists and async loading hooks.
    
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
            Current value rendered or edited by the control. The exact payload shape depends on the control type.
        options:
            Option descriptors shown in the dropdown.
        items:
            Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
        groups:
            Group descriptors for grouped option sections.
        label:
            Primary label text rendered by the control or its active action.
        hint:
            Hint text shown when input is empty.
        placeholder:
            Backward-compatible alias for ``hint``. When both fields are provided, ``hint`` takes precedence and this alias is kept only for compatibility.
        loading:
            If ``True``, shows loading affordances.
        async_source:
            Identifier used by your runtime for remote option lookups.
        debounce_ms:
            Debounce window (milliseconds) for query events.
        enabled:
            If ``False``, input is non-interactive.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
        props:
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
    """


    value: str | None = None
    """
    Current value rendered or edited by the control. The exact payload shape depends on the control type.
    """

    options: list[Any] | None = None
    """
    Option descriptors shown in the dropdown.
    """

    items: list[Any] | None = None
    """
    Ordered list of items rendered by the control. Each entry may be a strongly typed helper instance or a raw mapping matching the runtime payload shape.
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    Group descriptors for grouped option sections.
    """

    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    hint: str | None = None
    """
    Hint text shown when input is empty.
    """

    placeholder: str | None = None
    """
    Backward-compatible alias for ``hint``. When both fields are provided, ``hint`` takes precedence and this alias is kept only for compatibility.
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
    List of runtime event names that should be emitted back to Python for this control instance.
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
        merged = merge_props(
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
                    )
        super().__init__(
            props=merged,
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
