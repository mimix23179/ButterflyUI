from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Chip"]

class Chip(Component):
    """
    Compact selectable or dismissible chip widget.

    Renders a Flutter ``FilterChip`` or ``InputChip`` depending on the
    props.  When ``selected`` is ``True`` the chip is shown in its
    highlighted state.  Setting ``dismissible`` to ``True`` adds a
    trailing ``×`` button that emits a ``dismiss`` event.  Tapping the
    chip body emits a ``select`` event with the toggled state.
    :meth:`set_selected` lets you change the selection state
    imperatively.

    ```python
    import butterflyui as bui

    bui.Chip("Python", selected=True, dismissible=True)
    ```

    Args:
        label:
            Text label displayed inside the chip.
        value:
            Arbitrary identifier emitted with events.
        selected:
            If ``True``, the chip renders in its selected/highlighted
            state.
        enabled:
            If ``False``, the chip is non-interactive.
        dismissible:
            If ``True``, a trailing close button is shown; tapping it
            emits a ``dismiss`` event.
        color:
            Background colour of the chip when selected.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "chip"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dismissible: bool | None = None,
        color: Any | None = None,
        events: list[str] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            label=label,
            value=value,
            selected=selected,
            enabled=enabled,
            dismissible=dismissible,
            color=color,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def set_selected(self, session: Any, value: bool) -> dict[str, Any]:
        return self.invoke(session, "set_selected", {"value": value})

    def get_state(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_state", {})

    def emit(self, session: Any, event: str, payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
