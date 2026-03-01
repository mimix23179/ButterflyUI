from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props
from .button import Button

__all__ = ["ElevatedButton"]

class ElevatedButton(Button):
    """
    :class:`Button` preset with ``variant="elevated"``.

    Convenience subclass that forces the ``elevated`` visual variant so
    you don't have to specify it manually.  The Flutter side renders an
    ``ElevatedButton`` widget with a raised shadow.  All other
    :class:`Button` parameters apply unchanged.

    ```python
    import butterflyui as bui

    bui.ElevatedButton("Confirm", value="confirm")
    ```

    Args:
        label:
            Button caption text.  Alias ``text`` takes precedence.
        text:
            Button caption text (alias for ``label``).
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
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "elevated_button"

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
            variant="elevated",
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
