from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .button import Button

__all__ = ["IconButton"]

class IconButton(Button):
    """
    Tappable icon-only button control.

    ``IconButton`` is the icon-focused member of the button family. It keeps
    the full action/event behavior of :class:`Button` while prioritizing icon
    payloads over text captions. The runtime can resolve icon name strings,
    integer code points, and compatible icon payload objects.

    Use this for toolbar buttons, compact overlay actions, or quick actions
    where a label would add unnecessary visual weight.

    ```python
    import butterflyui as bui

    bui.IconButton(
        icon="delete",
        tooltip="Delete item",
        color="#FF4D6D",
        action_id="delete_current_item",
    )
    ```

    Args:
        icon:
            Material icon name, codepoint integer, or runtime icon payload.
        tooltip:
            Assistive tooltip text.
        size:
            Icon size in logical pixels.
        color:
            Icon color value accepted by runtime.
        enabled:
            If ``False``, the control is non-interactive.
        value:
            Arbitrary payload emitted with click events.
        events:
            Runtime event names to subscribe to.
        action:
            Declarative action descriptor fired on press.
        action_id:
            Registered action ID to dispatch on press.
        action_event:
            Event name forwarded to the action dispatcher.
        action_payload:
            Extra payload mapping for action dispatch.
        actions:
            Action descriptor list executed on press.
        props:
            Additional props merged before typed arguments.
        style:
            Optional style map for the control host.
        strict:
            Enables strict schema validation when supported.
        **kwargs:
            Extra runtime props forwarded to the renderer. This can include
            style/modifier/motion/effects fields and optional transparency.
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

