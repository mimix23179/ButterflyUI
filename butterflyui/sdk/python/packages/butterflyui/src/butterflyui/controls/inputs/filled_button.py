from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .button import Button

__all__ = ["FilledButton"]


class FilledButton(Button):
    """
    Filled emphasis button preset.
    
    ``FilledButton`` forwards all interaction, action dispatch, style, and
    customization behavior from :class:`Button` while forcing
    ``variant="filled"``. Use it for primary call-to-action surfaces where
    stronger visual emphasis is needed.
    
    In addition to typed parameters, runtime keys passed through ``**kwargs``
    are preserved. This includes optional icon/color/transparency props and
    style pipeline fields such as classes, modifiers, motion, and effects.

    Example:
    
    ```python
    import butterflyui as bui
    
    bui.FilledButton(
        "Deploy",
        action_id="deploy_release",
        icon="rocket_launch",
        transparency=0.04,
    )
    ```
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
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "filled_button"

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
        merged = merge_props(props, events=events)
        super().__init__(
            label=label,
            text=text,
            value=value,
            variant="filled",
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=action_payload,
            actions=actions,
            props=merged,
            style=style,
            strict=strict,
            **kwargs,
        )
