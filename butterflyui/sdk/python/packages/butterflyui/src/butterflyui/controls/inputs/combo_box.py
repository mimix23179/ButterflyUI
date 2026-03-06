from __future__ import annotations

from collections.abc import Mapping
from typing import Any
from ..base_control import butterfly_control
from ..selection_control import SelectionControl

__all__ = ["ComboBox"]

@butterfly_control('combo_box', positional_fields=('value',))
class ComboBox(SelectionControl):
    """
    Editable combo-box input with option lists and async loading hooks.

    ``ComboBox`` is the canonical merged control for both ``combo_box`` and
    legacy ``combobox`` usage. It supports typed input with selectable options,
    grouped option sections, loading state for remote queries, and debounce
    configuration for server-driven suggestion pipelines.

    Example:

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
    """

    groups: list[Mapping[str, Any]] | None = None
    """
    Group descriptors for grouped option sections.
    """

    hint: str | None = None
    """
    Hint text shown when input is empty.
    """

    loading: bool | None = None
    """
    If ``True``, shows loading affordances.
    """

    async_source: str | None = None
    """
    Identifier used by your runtime for remote option lookups.
    """

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": list(options)})

    def set_loading(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_loading", {"value": value})
