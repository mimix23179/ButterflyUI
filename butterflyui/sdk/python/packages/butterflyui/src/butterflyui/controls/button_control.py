from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from .layout_control import LayoutControl

__all__ = ["ButtonControl"]


class ButtonControl(LayoutControl):
    """
    Shared action-button behavior for clickable button controls.
    """

    label: str | None = None
    """
    Primary caption displayed by the button.
    """

    text: str | None = None
    """
    Caption alias used by button-like controls.
    """

    icon: Any = None
    """
    Leading or standalone icon rendered by the button.
    """

    icon_color: Any = None
    """
    Color applied to the button icon.
    """

    value: Any = None
    """
    Arbitrary payload emitted or carried with button interactions.
    """

    variant: str | None = None
    """
    Visual variant of the button, such as filled, outlined, or text.
    """

    autofocus: bool | None = None
    """
    Whether the button should request focus when first built.
    """

    action: Any = None
    """
    Declarative action descriptor fired when the button is pressed.
    """

    action_id: str | None = None
    """
    Registered action identifier dispatched on press.
    """

    action_event: str | None = None
    """
    Event name emitted to the action dispatcher when pressed.
    """

    action_payload: Mapping[str, Any] | None = None
    """
    Extra payload mapping passed to the action dispatcher.
    """

    actions: list[Any] | None = None
    """
    Action descriptor list executed when the button is pressed.
    """

    window_action: str | None = None
    """
    Native window command, such as minimize, maximize, or close.
    """

    window_action_delay_ms: int | None = None
    """
    Delay in milliseconds before a window action is performed.
    """
