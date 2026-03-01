from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .button import Button

__all__ = ["IconButton"]

class IconButton(Button):
    """
    Tappable icon button without a text label.

    Extends :class:`Button` and renders a Flutter ``IconButton``
    widget.  The ``icon`` parameter accepts a Material icon name
    string or a codepoint integer.  An optional ``tooltip`` is shown
    on long-press.  Tapping emits a ``click`` event together with any
    ``value`` payload.  Inherits full action dispatch support from
    :class:`Button`.

    ```python
    import butterflyui as bui

    bui.IconButton("delete", tooltip="Delete item", color="red")
    ```

    Args:
        icon:
            Material icon name (e.g. ``"add"``, ``"close"``) or
            Unicode codepoint integer.
        tooltip:
            Text shown in the long-press tooltip.
        size:
            Icon size in logical pixels.
        color:
            Icon colour — any Flutter-compatible colour value.
        enabled:
            If ``False``, the button is non-interactive.
        value:
            Arbitrary payload emitted with the ``click`` event.
        action:
            Declarative action descriptor dispatched on tap.
        action_id:
            ID of a registered server-side action.
        action_event:
            Event name forwarded to the action handler.
        action_payload:
            Extra payload mapping for the action.
        actions:
            List of action descriptors executed on tap.
    """
    control_type = "icon_button"

    def __init__(
        self,
        icon: str | int | None = None,
        *,
        tooltip: str | None = None,
        size: float | None = None,
        color: Any | None = None,
        enabled: bool | None = None,
        value: Any | None = None,
        events: list[str] | None = None,
        action: Any | None = None,
        action_id: str | None = None,
        action_event: str | None = None,
        action_payload: Mapping[str, Any] | None = None,
        actions: list[Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        super().__init__(
            label=None,
            props=merge_props(
                props,
                icon=icon,
                tooltip=tooltip,
                size=size,
                color=color,
                enabled=enabled,
                value=value,
            ),
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=action_payload,
            actions=actions,
            style=style,
            strict=strict,
            **kwargs,
        )
