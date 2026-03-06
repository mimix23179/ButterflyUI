from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["Button"]

class Button(Component):
    """
    Base interactive button control.
    
    ``Button`` is the shared click surface used by specialized button
    controls. It serializes caption, variant, events, and declarative actions
    into one runtime payload.
    
    In addition to typed parameters, extra keys passed via ``**kwargs`` are
    forwarded to runtime. This allows advanced visual and pipeline fields like
    ``icon``, ``color``, ``transparency``, ``classes``, ``modifiers``,
    ``motion``, and ``effects``.
    "

    Example:

    ```python
    import butterflyui as bui
    
    bui.Button(
        "Submit",
        variant="filled",
        action_id="submit_form",
        icon="send",
        transparency=0.08,
    )
    ```
    """


    label: str | None = None
    """
    Caption text. Alias ``text`` takes precedence when both are set.
    """

    text: str | None = None
    """
    Caption text alias for ``label``.
    """

    value: Any | None = None
    """
    Arbitrary payload emitted with click events.
    """

    variant: str | None = None
    """
    Visual variant, such as ``"filled"``, ``"outlined"``,
    ``"text"``, ``"elevated"``, or ``"tonal"``.
    """

    events: list[str] | None = None
    """
    List of runtime event names that should be emitted back to Python for this control instance.
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

    window_action: str | None = None
    """
    Native window command, for example ``"minimize"``,
    ``"maximize"``, or ``"close"``.
    """

    window_action_delay_ms: int | None = None
    """
    Delay before running ``window_action``.
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

