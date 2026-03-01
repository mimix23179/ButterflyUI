from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["CheckList"]

class CheckList(Component):
    """
    Scrollable list of labelled check-boxes built from an options array.

    The runtime renders one ``CheckboxListTile`` per item in ``options``.
    The currently checked items are identified by matching against
    ``values``.  Toggling any row emits a ``change`` event carrying the
    updated ``values`` list.  Use :meth:`set_values` or
    :meth:`get_values` to read/write the selection imperatively.

    ```python
    import butterflyui as bui

    bui.CheckList(
        options=["Apples", "Bananas", "Cherries"],
        values=["Apples"],
    )
    ```

    Args:
        options:
            List of option items.  Each item may be a plain string,
            or a mapping with at least a ``"label"`` key and an
            optional ``"value"`` key.
        values:
            List of currently selected values.
        dense:
            If ``True``, tiles use compact height.
        enabled:
            If ``False``, all check-boxes are disabled.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "check_list"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        dense: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            values=values,
            dense=dense,
            enabled=enabled,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def get_values(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_values", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
