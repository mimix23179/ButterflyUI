from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["MultiSelect"]

class MultiSelect(Component):
    """
    Multi-value selector that renders selected items as chips.

    The Flutter runtime renders a dropdown-style widget where selected
    values are displayed as ``InputChip`` tokens inside the field.
    The user can open the dropdown to toggle additional options or
    remove existing selections by tapping the chip close button.
    Selection changes emit a ``change`` event with the updated
    ``values`` list.  Use :meth:`set_values`, :meth:`set_options`,
    or :meth:`get_values` to drive the control from Python.

    ```python
    import butterflyui as bui

    bui.MultiSelect(
        options=["Python", "Dart", "Go", "Rust"],
        values=["Python"],
        label="Languages",
    )
    ```

    Args:
        options:
            List of option items (strings or mappings with
            ``"label"``/``"value"`` keys).
        values:
            Currently selected values.  Alias ``selected`` is kept
            in sync.
        selected:
            Alias for ``values``.
        label:
            Label text shown above the selector field.
        enabled:
            If ``False``, the control is non-interactive.
    """
    control_type = "multi_select"

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
        merged = merge_props(
            props,
            options=options,
            values=values if values is not None else selected,
            selected=selected if selected is not None else values,
            label=label,
            enabled=enabled,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
