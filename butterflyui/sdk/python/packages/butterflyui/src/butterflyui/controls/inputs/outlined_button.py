from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .button import Button

__all__ = ["OutlinedButton"]


class OutlinedButton(Button):
    """
    Outlined emphasis button preset.

    ``OutlinedButton`` uses :class:`Button` behavior and forces
    ``variant="outlined"`` for medium-emphasis actions. It supports the same
    click events, declarative action dispatch, and runtime style/customization
    forwarding as the base button family.

    ```python
    import butterflyui as bui

    bui.OutlinedButton(
        "Inspect",
        action_event="open_inspector",
        icon="search",
    )
    ```

    Args:
        label:
            Button caption text. ``text`` takes precedence when both are set.
        text:
            Caption text alias for ``label``.
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
            Extra runtime props forwarded to the renderer.
    """


    label: str | None = None
    """
    Button caption text. ``text`` takes precedence when both are set.
    """

    text: str | None = None
    """
    Caption text alias for ``label``.
    """

    value: Any | None = None
    """
    Arbitrary payload emitted with click events.
    """

    action: Any | None = None
    """
    Declarative action descriptor fired on press.
    """

    action_id: str | None = None
    """
    Registered action ID to dispatch on press.
    """

    action_event: str | None = None
    """
    Event name forwarded to the action dispatcher.
    """

    action_payload: Mapping[str, Any] | None = None
    """
    Extra payload mapping for action dispatch.
    """

    actions: list[Any] | None = None
    """
    Action descriptor list executed on press.
    """


    events: list[str] | None = None
    """
    Runtime event names to subscribe to.
    """

    control_type = "outlined_button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
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
            label=label,
            text=text,
            value=value,
            variant="outlined",
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=action_payload,
            actions=actions,
            props=merge_props(props, events=events),
            style=style,
            strict=strict,
            **kwargs,
        )
