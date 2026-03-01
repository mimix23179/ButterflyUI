from __future__ import annotations
from collections.abc import Mapping
from typing import Any
from .._shared import Component, merge_props

__all__ = ["ButtonStyle"]

class ButtonStyle(Component):
    """
    Style-preset picker rendered as a row of ``ChoiceChip`` widgets.

    The default presets are ``"solid"``, ``"outline"``, and ``"ghost"``.
    Selecting a chip emits a ``"change"`` event with the chosen preset's
    ``id``. The control also supports per-state style overrides (base,
    hover, pressed) and a full action/event dispatch system.

    ```python
    import butterflyui as bui

    bui.ButtonStyle(
        value="solid",
        options=[
            {"id": "solid", "label": "Solid"},
            {"id": "outline", "label": "Outline"},
            {"id": "ghost", "label": "Ghost"},
        ],
    )
    ```

    Args:
        value: 
            Currently selected style preset ``id``.
        options: 
            List of preset descriptors, each a dict with ``"id"`` and ``"label"`` keys. Defaults to solid / outline / ghost.
        items: 
            Alias for `options`.
        base: 
            Style properties applied in the default (idle) button state.
        hover: 
            Style overrides applied when the button is hovered.
        pressed: 
            Style overrides applied while the button is pressed.
        disabled: 
            Style overrides applied when the button is disabled.
        focus_ring: 
            Configuration for the focus-ring appearance when the button is focused.
        motion_behavior: 
            Motion/animation configuration for state transitions.
        action: 
            Action identifier dispatched when the selected preset changes.
        actions: 
            List of action descriptors fired on change.
        action_id: 
            Specific action id to emit on change.
        action_event: 
            Event name used when dispatching the action.
        action_payload: 
            Additional payload merged into the action dispatch.
    """
    control_type = "button_style"

    def __init__(
        self,
        value: str | None = None,
        *,
        options: list[Any] | None = None,
        items: list[Any] | None = None,
        base: Mapping[str, Any] | None = None,
        hover: Mapping[str, Any] | None = None,
        pressed: Mapping[str, Any] | None = None,
        disabled: Mapping[str, Any] | None = None,
        focus_ring: Mapping[str, Any] | None = None,
        motion_behavior: Mapping[str, Any] | None = None,
        action: Any | None = None,
        actions: list[Any] | None = None,
        action_id: str | None = None,
        action_event: str | None = None,
        action_payload: Mapping[str, Any] | None = None,
        props: Mapping[str, Any] | None = None,
        style: Mapping[str, Any] | None = None,
        strict: bool = False,
        **kwargs: Any,
    ) -> None:
        merged = merge_props(
            props,
            value=value,
            options=options if options is not None else items,
            items=items,
            base=dict(base) if base is not None else None,
            hover=dict(hover) if hover is not None else None,
            pressed=dict(pressed) if pressed is not None else None,
            disabled=dict(disabled) if disabled is not None else None,
            focus_ring=dict(focus_ring) if focus_ring is not None else None,
            motion_behavior=dict(motion_behavior) if motion_behavior is not None else None,
            action=action,
            actions=actions,
            action_id=action_id,
            action_event=action_event,
            action_payload=dict(action_payload) if action_payload is not None else None,
            **kwargs,
        )
        super().__init__(props=merged, style=style, strict=strict)

    def get_value(self, session: Any) -> dict[str, Any]:
        return self.invoke(session, "get_value", {})

    def set_value(self, session: Any, value: str) -> dict[str, Any]:
        return self.invoke(session, "set_value", {"value": value})

    def set_options(self, session: Any, options: list[Any]) -> dict[str, Any]:
        return self.invoke(session, "set_options", {"options": options})

    def set_state_style(self, session: Any, state: str, style_props: Mapping[str, Any]) -> dict[str, Any]:
        return self.invoke(session, "set_state_style", {"state": state, "style": dict(style_props)})
