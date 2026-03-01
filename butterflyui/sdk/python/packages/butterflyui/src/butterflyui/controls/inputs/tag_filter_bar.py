from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["TagFilterBar"]

class TagFilterBar(Component):
    """
    Horizontally scrollable bar of filter chip tags.

    Renders a ``SingleChildScrollView`` containing a ``Wrap`` or
    ``Row`` of ``FilterChip`` / ``InputChip`` widgets, one per entry
    in ``options``.  In single-select mode only one chip can be active;
    in multi-select mode any combination is allowed.  Selection changes
    emit a ``change`` event with the updated ``values`` list.  Use
    :meth:`set_values`, :meth:`set_options`, and :meth:`get_state` to
    drive the bar from Python.

    ```python
    import butterflyui as bui

    bui.TagFilterBar(
        options=["All", "Active", "Done", "Archived"],
        values=["All"],
        multi_select=False,
    )
    ```

    Args:
        options:
            List of filter items (strings or mappings with
            ``"label"``/``"value"`` keys).
        values:
            Currently active filter values.
        multi_select:
            If ``True``, multiple chips can be active simultaneously.
        dense:
            If ``True``, chips use compact height and padding.
    """
    control_type = "tag_filter_bar"

    def __init__(
        self,
        *,
        options: list[Any] | None = None,
        values: list[Any] | None = None,
        multi_select: bool | None = None,
        dense: bool | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            options=options,
            values=values,
            multi_select=multi_select,
            dense=dense,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def set_values(self, session: Any, values: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_values", {"values": values})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
