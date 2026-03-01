from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Button"]

class Button(Component):
    """
    General-purpose clickable button.

    Renders a Flutter button widget whose visual style is controlled by
    ``variant``.  When no variant is given the runtime applies its default
    filled style.  The ``label`` / ``text`` values are shown as the button
    caption.  Tapping the button emits a ``click`` event together with any
    ``value`` payload.

    Declarative actions (``action``, ``action_id``, ``actions``) allow the
    button to trigger server-side handlers or sequences of operations
    without writing an explicit event listener.  ``window_action`` lets
    the button control native window behaviour directly from Python.

    ```python
    import butterflyui as bui

    bui.Button("Submit", variant="filled", value="submit")
    ```

    Args:
        label:
            Button caption text.  Alias ``text`` takes precedence when
            both are supplied.
        text:
            Button caption text (alias for ``label``).
        value:
            Arbitrary payload emitted alongside the ``click`` event.
        variant:
            Visual style variant — e.g. ``"filled"``, ``"outlined"``,
            ``"text"``, ``"elevated"``, ``"tonal"``.
        action:
            Declarative action descriptor dispatched when the button is
            tapped.
        action_id:
            ID of a registered server-side action to invoke on tap.
        action_event:
            Event name forwarded to the action handler.
        action_payload:
            Extra mapping forwarded with the action invocation.
        actions:
            List of action descriptors executed sequentially on tap.
        window_action:
            Native window command triggered on tap — e.g.
            ``"minimize"``, ``"maximize"``, ``"close"``.
        window_action_delay_ms:
            Milliseconds to wait before executing ``window_action``.
        events:
            List of event names the Flutter runtime should emit to Python.
    """
    control_type = "button"

    def __init__(
        self,
        label: str | None = None,
        *,
        text: str | None = None,
        value: Any | None = None,
        variant: str | None = None,
        events: list[str] | None = None,
        action: Any | None = None,
        action_id: str | None = None,
        action_event: str | None = None,
        action_payload: Mapping[str, Any] | None = None,
        actions: list[Any] | None = None,
        window_action: str | None = None,
        window_action_delay_ms: int | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        resolved = text if text is not None else label
        merged = merge_props(
            props,
            label=resolved,
            text=resolved,
            value=value,
            variant=variant,
            events=events,
            action=action,
            action_id=action_id,
            action_event=action_event,
            action_payload=dict(action_payload) if action_payload is not None else None,
            actions=actions,
            window_action=window_action,
            window_action_delay_ms=window_action_delay_ms,
        )
        super().__init__(props=merged, style=style, strict=strict, **kwargs)
