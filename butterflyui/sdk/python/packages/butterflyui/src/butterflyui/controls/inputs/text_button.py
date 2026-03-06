from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .._shared import merge_props
from .button import Button

__all__ = ["TextButton"]


class TextButton(Button):
    """Low-emphasis text button preset.
    
    ``TextButton`` reuses :class:`Button` behavior while forcing
    ``variant="text"``. It is suited for tertiary actions, inline links, and
    toolbar actions where minimal chrome is preferred.
    
    The control still supports action IDs, action payloads, and runtime event
    emission. Additional visual/runtime props can be supplied through
    ``**kwargs``.
    
    ```python
    import butterflyui as bui
    
    bui.TextButton(
        "Undo",
        action_id="undo_last",
        icon="undo",
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
            List of runtime event names that should be emitted back to Python for this control instance.
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
            Raw prop overrides merged into the payload sent to Flutter. Use this when the Python wrapper does not yet expose a runtime key as a first-class argument.
        style:
            Local style map merged into the rendered control payload. Use it for per-instance styling without changing shared tokens, variants, or recipe classes.
        strict:
            Enables strict validation for unsupported or unknown props when schema checks are available. This is useful while developing wrappers or debugging payload mismatches.
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
    List of runtime event names that should be emitted back to Python for this control instance.
    """

    control_type = "text_button"

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
            variant="text",
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
