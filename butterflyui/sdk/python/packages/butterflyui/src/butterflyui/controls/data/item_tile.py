from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .list_tile import ListTile

__all__ = ["ItemTile"]

class ItemTile(ListTile):
    """
    Selectable list tile tailored for data-oriented item rows, extending
    ``ListTile`` with an ``events`` convenience parameter and invoke
    helpers for runtime state management.

    Renders the same ``ListTile`` widget as its parent class —
    ``title``, optional ``subtitle``, ``leading_icon``, and
    ``trailing_icon`` — but also surfaces ``set_selected()``,
    ``get_state()``, and ``emit()`` helpers for driving the tile from
    Python.  Tapping the tile emits a ``"select"`` event whose payload
    includes the ``id``, ``title``, ``value``, and ``meta`` fields when
    present.

    ```python
    import butterflyui as bui

    bui.ItemTile(
        title="Build artefact",
        subtitle="245 KB",
        leading_icon="package",
        trailing_icon="chevron_right",
        selected=False,
    )
    ```

    Args:
        title: 
            Primary title text displayed on the tile.
        subtitle: 
            Secondary supporting text rendered beneath the title.
        leading_icon: 
            Icon name or data rendered at the leading edge of the tile.
        trailing_icon: 
            Icon name or data rendered at the trailing edge.
        meta: 
            Additional metadata string displayed as trailing text or forwarded in event payloads.
        selected: 
            If ``True``, the tile renders in its selected visual state.
        enabled: 
            If ``False``, the tile is visually dimmed and non-interactive.
        events:
            List of event names the Flutter runtime should emit to Python.
    """

    control_type = "item_tile"

    def __init__(
        self,
        *,
        title: str | None = None,
        subtitle: str | None = None,
        leading_icon: str | None = None,
        trailing_icon: str | None = None,
        meta: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            title=title,
            subtitle=subtitle,
            leading_icon=leading_icon,
            trailing_icon=trailing_icon,
            meta=meta,
            selected=selected,
            enabled=enabled,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
