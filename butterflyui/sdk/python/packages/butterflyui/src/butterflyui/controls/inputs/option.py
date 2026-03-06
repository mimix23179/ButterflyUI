from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Option"]

class Option(Component):
    """Single selectable option item for use inside list or select controls.
    
    Renders a ``ListTile``-style item with an optional leading icon,
    description subtitle, and checkbox/radio indicator depending on
    the parent context.  Tapping the item emits a ``select`` event
    carrying ``label`` and ``value``.  Setting ``selected`` pre-checks
    the item; setting ``enabled`` to ``False`` makes it non-interactive.
    
    ```python
    import butterflyui as bui
    
    bui.Option(
        "Python",
        value="python",
        description="General-purpose scripting language",
        icon="code",
    )
    ```
    
    Args:
        label:
            Primary label text rendered by the control or its active action.
        value:
            Machine-readable value emitted with selection events.
        description:
            Secondary subtitle text rendered below the label.
        icon:
            Icon value or icon descriptor rendered by the control.
        selected:
            If ``True``, the option is pre-selected.
        enabled:
            If ``False``, the option is non-interactive.
        dense:
            If ``True``, the item uses compact height.
        events:
            List of runtime event names that should be emitted back to Python for this control instance.
    """


    label: str | None = None
    """
    Primary label text rendered by the control or its active action.
    """

    value: Any | None = None
    """
    Machine-readable value emitted with selection events.
    """

    description: str | None = None
    """
    Secondary subtitle text rendered below the label.
    """

    icon: str | None = None
    """
    Icon value or icon descriptor rendered by the control.
    """

    selected: bool | None = None
    """
    If ``True``, the option is pre-selected.
    """

    dense: bool | None = None
    """
    If ``True``, the item uses compact height.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
    """
    control_type = "option"

    def __init__(
        self,
        label: str | None = None,
        *,
        value: Any | None = None,
        description: str | None = None,
        icon: str | None = None,
        selected: bool | None = None,
        enabled: bool | None = None,
        dense: bool | None = None,
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
            description=description,
            icon=icon,
            selected=selected,
            enabled=enabled,
            dense=dense,
            events=events,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def emit(self, session: Any, event: str = "select", payload: Mapping[str, Any] | None = None) -> dict[str, Any]:
        return self.invoke(session, "emit", {"event": event, "payload": dict(payload or {})})
