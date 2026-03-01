from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["FilterDrawer"]

class FilterDrawer(Component):
    """
    Slide-out panel with a schema-driven filter form.

    The Flutter runtime renders an ``EndDrawer`` (or inline panel)
    containing filter fields generated from a JSON ``schema``.  The
    current filter values are held in ``state``.  When ``show_actions``
    is ``True`` an *Apply* and a *Clear* button are shown at the
    bottom; tapping them emits ``"apply"`` and ``"clear"`` events
    respectively.  Filter changes also emit ``"change"`` events.
    Any explicit child controls are rendered inside the panel body
    above the generated schema fields.

    Use :meth:`set_open` to open/close the drawer imperatively,
    :meth:`set_state` to push new filter values, and
    :meth:`get_state` to read the current filter state.

    ```python
    import butterflyui as bui

    bui.FilterDrawer(
        title="Filters",
        schema={
            "status": {"type": "select", "options": ["Open", "Closed"]},
            "priority": {"type": "select", "options": ["Low", "High"]},
        },
        state={"status": "Open"},
        show_actions=True,
    )
    ```

    Args:
        title:
            Header text displayed at the top of the drawer.
        open:
            If ``True``, the drawer is initially open.
        schema:
            Dictionary describing the filter fields to auto-generate.
            Each key is a field ID; the value is a mapping with at
            least a ``"type"`` entry (e.g. ``"select"``,
            ``"checkbox"``, ``"text"``).
        state:
            Current filter values keyed by field ID.
        show_actions:
            If ``True``, *Apply* and *Clear* action buttons are shown.
        apply_label:
            Custom label for the apply button.  Defaults to
            ``"Apply"``.
        clear_label:
            Custom label for the clear button.  Defaults to
            ``"Clear"``.
        dense:
            If ``True``, generated fields use compact height.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "filter_drawer"

    def __init__(
        self,
        *children: Any,
        title: str | None = None,
        open: bool | None = None,
        schema: Mapping[str, Any] | None = None,
        state: Mapping[str, Any] | None = None,
        show_actions: bool | None = None,
        apply_label: str | None = None,
        clear_label: str | None = None,
        dense: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            title=title,
            open=open,
            schema=dict(schema or {}),
            state=dict(state or {}),
            show_actions=show_actions,
            apply_label=apply_label,
            clear_label=clear_label,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(*children, props=merged, style=style, strict=strict)

    def set_open(self, session: Any, open: bool) -> dict[str, Any]:
        return self.invoke(session, "set_open", {"open": open})

    def set_state(self, session: Any, state: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state", {"state": dict(state)})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
